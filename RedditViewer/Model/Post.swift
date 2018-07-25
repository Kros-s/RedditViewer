//
//  Post.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/23/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import Foundation

struct RedditObject: Codable {
    let data: Contents?
}

struct Contents: Codable {
    let children: [Children]?
}

struct Children: Codable {
    let data: Post?
}

struct Post: Codable {
    let title: String?
    let subreddit_name_prefixed: String?
    let subreddit: String?
    let url: String?
    let permalink: String?
    let thumbnail: String?
}
