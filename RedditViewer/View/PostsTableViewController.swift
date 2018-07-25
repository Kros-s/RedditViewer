//
//  ViewController.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/23/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit
import Siesta

class PostsTableViewController: UITableViewController, ResourceObserver {
    
    let expandableArea = ExpandableView()
    var leftConstraint: NSLayoutConstraint!
    let searchBar = UISearchBar()

    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        
        guard let response: RedditObject = resource.typedContent() else { return }
        guard let childrenContainer = response.data?.children else { return }
        let posts = childrenContainer.compactMap { (child) -> Post? in
            return child.data
        }
        self.posts = posts
    }
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let presenter: Presenter! = Presenter()
    var response: Resource? {
        didSet {
            
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            
            response?.addObserver(self)
                //.posts(statusOverlay, owner: self)
                .loadIfNeeded()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        response = presenter.currentPosts()
        setupView()
    }
    
    func setupView() {
        
        navigationItem.titleView = expandableArea
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggle))
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        expandableArea.addSubview(searchBar)
        searchBar.placeholder = "Place the subcategory here"
        
        //LeftConstraint
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableArea.leftAnchor)
        leftConstraint.isActive = false
        searchBar.rightAnchor.constraint(equalTo: expandableArea.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: expandableArea.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: expandableArea.bottomAnchor).isActive = true

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellPost", for: indexPath) as! contentTableViewCell
        
        let postItem = posts[indexPath.row] as Post
        cell.title.text = postItem.title
        cell.subReddit.text = postItem.subreddit
        
        cell.leftIcon.imageURL = postItem.thumbnail
        
        // FIXME: Move this to the init on the Cell
        //Setup for the view
        cell.leftIcon.layer.borderWidth = 1.0
        cell.leftIcon.layer.masksToBounds = false
        cell.leftIcon.layer.borderColor = UIColor.white.cgColor
        cell.leftIcon.layer.cornerRadius = 40
        cell.leftIcon.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "s_preview", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "s_preview" {
            let destinationVC = segue.destination as UIViewController
            destinationVC.view.backgroundColor = UIColor.clear
        }
    }
    
}

extension PostsTableViewController {
    @objc func toggle() {
        
        let isVisible = leftConstraint.isActive == true
        
        // Inactivating the left constraint closes the expandable header.
        leftConstraint.isActive = !isVisible
        
        // Animate change to visible.
        UIView.animate(withDuration: 1, animations: {
            self.navigationItem.titleView?.alpha =  !isVisible ? 1 : 0
            self.navigationItem.titleView?.layoutIfNeeded()
        })
    }
}
