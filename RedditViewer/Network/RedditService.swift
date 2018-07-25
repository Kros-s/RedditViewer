//
//  RedditService.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/23/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import Siesta

class RedditService {
    let baseUrl: String! = "https://www.reddit.com"
    var service: Service!
    let decoder = JSONDecoder()
    
    init() {
        
        #if DEBUG
        LogCategory.enabled = [.network]
        #endif
        service = Service(baseURL: baseUrl, standardTransformers: [.image, .text])
        
        // Process response data as a json in order to don't use Dictionaries
        service.configureTransformer("/.json") {
            // Input type inferred because the from: param takes Data.
            // Output type inferred because jsonDecoder.decode() will return RedditObject
            try self.decoder.decode(RedditObject.self, from: $0.content)
        }
        
        // Process response data as a json in order to don't use Dictionaries
        service.configureTransformer("/r/*/.json") {
            // Input type inferred because the from: param takes Data.
            // Output type inferred because jsonDecoder.decode() will return RedditObject
            try self.decoder.decode(RedditObject.self, from: $0.content)
        }
    }
    
    var activePosts: Resource {
        return service.resource("/.json")
    }
    
    /// Get post based on input
    ///
    /// - Parameter subreddit: string
    /// - Returns: resource
    func getSubreddit(_ subreddit: String) -> Resource {
        let path = "/r/\(subreddit)/.json"
        return service.resource(path)
    }
    
    deinit {
        self.service = nil
    }
}
