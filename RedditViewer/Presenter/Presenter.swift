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
    
    let service: RedditService!
    
    init() {
        service = RedditService()
    }
    
    func currentPosts() -> Resource {
        return service.activePosts
    }
//    
//    func getCategory() -> Response {
//        return service
//    }

}
