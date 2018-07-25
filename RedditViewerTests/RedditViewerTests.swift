//
//  RedditViewerTests.swift
//  RedditViewerTests
//
//  Created by Marco Antonio Mayen Hernandez on 7/23/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import XCTest
import Siesta
@testable import RedditViewer

class RedditViewerTests: XCTestCase {
    var table: PostsTableViewController!
    var posts: [Post] = []
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in  the class.
        table = PostsTableViewController()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAllPosts() {
        let expectation = self.expectation(description: "Loading data")
        table.presenter.currentPosts().addObserver(owner: self) { (resource, event) in
            guard let response: RedditObject = resource.typedContent() else { return }
            guard let childrenContainer = response.data?.children else { return }
            let posts = childrenContainer.compactMap { (child) -> Post? in
                return child.data
            }
            self.posts = posts
            expectation.fulfill()
        }.load()
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssert(!self.posts.isEmpty, "Great we are getting data from service")
    }
    
    func testCategory() {
        let expectation = self.expectation(description: "Loading data")
        table.presenter.getPostsIn(category: "gifs").addObserver(owner: self) { (resource, event) in
            guard let response: RedditObject = resource.typedContent() else { return }
            guard let childrenContainer = response.data?.children else { return }
            let posts = childrenContainer.compactMap { (child) -> Post? in
                return child.data
            }
            self.posts = posts
            expectation.fulfill()
            }.load()
        waitForExpectations(timeout: 60, handler: nil)
        XCTAssert(!self.posts.isEmpty)
        
        guard let checkCategory = self.posts.first?.subreddit else {
            XCTFail("The subreddit is not present")
            return
        }
        XCTAssert(checkCategory.lowercased() == "gifs", "All categories are gifs")
        
    }
    
}
