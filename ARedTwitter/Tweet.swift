//
//  Tweet.swift
//  ARedTwitter
//
//  Created by admin on 9/27/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

let replyImageURL: String = "https://si0.twimg.com/images/dev/cms/intents/icons/reply.png"
let retweetImageURL = "https://si0.twimg.com/images/dev/cms/intents/icons/retweet.png"
let favoriteImageURL = "https://si0.twimg.com/images/dev/cms/intents/icons/favorite.png"
let favoriteOnImageURL: String = "https://si0.twimg.com/images/dev/cms/intents/icons/favorite_on.png"
let retweetOnImageURL: String = "https://si0.twimg.com/images/dev/cms/intents/icons/retweet_on.png"


class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var creationDateString: String?
    var creationDate: NSDate?
    
    var retweetCount: String?
    var favoriteCount: String?
    
    
    var id: Int?
    var favorited: Bool?
    var retweeted: Bool?
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        creationDateString = dictionary["created_at"] as? String
        
        retweetCount = String(dictionary["retweet_count"] as Int)
        favoriteCount = String(dictionary["favorite_count"] as Int)
        
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        creationDate = formatter.dateFromString(creationDateString!)

        id = dictionary["id"] as? Int
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func markFavorite(id: Int) {
        TwitterClient.sharedInstance.markFavoriteWithCompletion(id, {(error) -> () in
            if error == nil {
                println("Tweet Favorited successfully")
            }
        })
    }
    
    func unFavorite(id: Int) {
        TwitterClient.sharedInstance.unFavoriteWithCompletion(id, {(error) -> () in
            if error == nil {
                println("Tweet UnFavorited successfully")
            }
        })
    }
    
    func markRetweeted(id: Int) {
        TwitterClient.sharedInstance.markRetweetWithCompletion(id, {(error) -> () in
            if error == nil {
                println("Tweet Retweeted successfully")
            }
        })
    }
    


    
}
