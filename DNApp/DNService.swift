//
//  DNService.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/03/07.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import Alamofire

struct DNService {
    
    // Doc: https://github.com/metalabdesign/dn_api_v2
    
    private static let baseURL = "https://www.designernews.co"
    private static let clientID = "750ab22aac78be1c6d4bbe584f0e3477064f646720f327c5464bc127100a1a6d"
    private static let clientSecret = "53e3822c49287190768e009a8f8e55d09041c5bf26d0ef982693f215c72d87da"
    
    private enum ResourcePath: CustomStringConvertible {
        case Login
        case Stories
        case StoryId(storyId: Int)
        case StoryUpvote(storyId: Int)
        case StoryReply(storyId: Int)
        case CommentUpvote(commentId: Int)
        case CommentReply(commentId: Int)
        
        var description: String {
            switch self {
            case .Login: return "/oauth/token"
            case .Stories: return "/api/v1/stories"
            case .StoryId(let id): return "/api/v1/stories/\(id)"
            case .StoryUpvote(let id): return "/api/v1/stories/\(id)/upvote"
            case .StoryReply(let id): return "/api/v1/stories/\(id)/reply"
            case .CommentUpvote(let id): return "/api/v1/comments/\(id)/upvote"
            case .CommentReply(let id): return "/api/v1/comments/\(id)/reply"
            }
        }
    }
    
    static func storiesForSection(section: String, page: Int, handler: (JSON) -> ()) {
        let urlString = baseURL + ResourcePath.Stories.description + "/" + section
        let parameters = [
            "page": String(page),
            "client_id": clientID
        ]
        Alamofire.request(.GET, urlString, parameters: parameters).responseJSON { response in
            let stories = JSON(response.result.value ?? [])
            handler(stories)
        }
    }
    
    static func loginWithEmail(email: String, password: String, handler: (token: String?) -> ()) {
        let urlString = baseURL + ResourcePath.Login.description
        let parameters = [
            "grant_type": "password",
            "username": email,
            "password": password,
            "client_id": clientID,
            "client_secret": clientSecret
        ]
        Alamofire.request(.POST, urlString, parameters: parameters).responseJSON { response in
            let json = JSON(response.result.value!)
            let token = json["access_token"].string
            handler(token: token)
        }
    }
    
    static func upvoteStoryWithId(storyId: Int, token: String, response: (successful: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.StoryUpvote(storyId: storyId).description
        upvoteWithUrlString(urlString, token: token, handler: response)
    }
    
    static func upvoteCommentWithId(commentId: Int, token: String, response: (successful: Bool) -> ()) {
        let urlString = baseURL + ResourcePath.CommentUpvote(commentId: commentId).description
        upvoteWithUrlString(urlString, token: token, handler: response)
    }
    
    private static func upvoteWithUrlString(urlString: String, token: String, handler: (successful: Bool) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(request).responseJSON { response in
            let successful = response.response?.statusCode == 200
            handler(successful: successful)
        }
    }
}
