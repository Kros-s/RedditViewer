//
//  Presenter.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/24/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import Foundation
import Siesta

class Presenter {
    // Don't like to had a singleton here according to Siesta api
    // Since singletons are anti-pattern
    var service: RedditService!
    
    init() {
        service = RedditService()
    }
    
    func currentPosts() -> Resource {
        return service.activePosts
    }
    
    func getPostsIn(category: String) -> Resource {
        return service.getSubreddit(category)
    }
    
    deinit {
        service = nil
    }

}
