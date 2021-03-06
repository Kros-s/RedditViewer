//
//  ViewController.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/23/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit
import Siesta

class PostsTableViewController: UITableViewController {
    
    let presenter: Presenter! = Presenter()
    let expandableArea = ExpandableView()
    var leftConstraint: NSLayoutConstraint!
    let searchBar = UISearchBar()
    var selectedRow: Int = 0
    
    //Resource will populate this one always and trigger the update on the tableView
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var response: Resource? {
        didSet {
            // Need to remove this observer in order to don't save cache for the previous api calls made
            oldValue?.removeObservers(ownedBy: self)
            // Adding ourselves as an observer triggers an immediate call to resourceChanged().
            response?.addObserver(self)
                .loadIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: "s_preview", sender: nil)
    }
    
    /// Getting ready for the next view, here we sent the data to the next view
    ///
    /// - Parameters:
    ///   - segue: segue being called
    ///   - sender:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "s_preview" {
            let destinationVC = segue.destination as! PreviewViewController
            destinationVC.view.backgroundColor = UIColor.clear
            destinationVC.preview.imageURL = posts[selectedRow].thumbnail
            destinationVC.posTtitle.text = posts[selectedRow].title
            destinationVC.stringUrl = posts[selectedRow].url
            destinationVC.renderPage()
        }
    }
    
}

extension PostsTableViewController {
    
    /// Toggles constraint and hide/show tittle (expandableView) in order
    /// to create an animation for SearchBar
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
    
    /// Initializer for all setup necesary for the Post Screen
    func setupView() {
        response = presenter.currentPosts()
        
        navigationItem.titleView = expandableArea
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(toggle))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        expandableArea.addSubview(searchBar)
        searchBar.placeholder = "Place the subcategory here"
        searchBar.delegate = self
        
        //LeftConstraint
        leftConstraint = searchBar.leftAnchor.constraint(equalTo: expandableArea.leftAnchor)
        leftConstraint.isActive = false
        searchBar.rightAnchor.constraint(equalTo: expandableArea.rightAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: expandableArea.topAnchor).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: expandableArea.bottomAnchor).isActive = true
        
    }
}

extension PostsTableViewController: ResourceObserver {
    /// Detecs when our resource changed by using this delegate allows us to keep track of the changes
    ///
    /// - Parameters:
    ///   - resource: resource returned by service
    ///   - event: type of event coming 
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        
        guard let response: RedditObject = resource.typedContent() else { return }
        guard let childrenContainer = response.data?.children else { return }
        let posts = childrenContainer.compactMap { (child) -> Post? in
            return child.data
        }
        self.posts = posts
    }
}

extension PostsTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        response = presenter.currentPosts()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        response = presenter.currentPosts()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        response = presenter.currentPosts()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        response = presenter.currentPosts()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Ultra easy for update searchs, with the help of the observer in siesta
        if !searchText.isEmpty {
            response = presenter.getPostsIn(category: searchText)
        } else {
            response = presenter.currentPosts()
        }
        
    }
}
