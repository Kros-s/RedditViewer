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
//        let nib = UINib(nibName: "contentTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

