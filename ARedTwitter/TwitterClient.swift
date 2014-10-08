//
//  TwitterClient.swift
//  ARedTwitter
//
//  Created by admin on 10/3/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

let twitterConsumerKey = "H2MJfmextnHtys8dk0nrsrL5h"
let twitterConsumerSecret = "5J1qMGauFzgz4v0hU9a7PZE1gisBCANkLlkQYqYCs6ScSZTMui"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
   
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        
        struct Static {
            
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
            
        return Static.instance
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> () ) {
        loginCompletion = completion
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath(
            "oauth/request_token", method: "GET", callbackURL: NSURL(string: "ARedTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
                println("Got the Request Token")
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL)
            }) { (error: NSError!) -> Void in
                println("Error in receiving the Request Token: \(error)")
                
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            println("Got the Access Token")
            //TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("User: \(response)")
                
                var user = User(dictionary: response as NSDictionary)
                println("username: \(user.name)")
                
                User.currentUser = user
                
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Error getting the current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive the Access Token")
                self.loginCompletion?(user: nil, error: error)
        }

        
    }
    
    func getTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> () ) {
        var tweets: [Tweet] = [Tweet]()
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("Home timeline: \(response)")
            
            tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            for tweet in tweets {
                
                //println("Tweet Text: \(tweet.text), Created: \(tweet.creationDate)")
            }
            
            completion(tweets: tweets, error: nil)
            
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error receiving home timeline: \(error)")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func getUserTimelineWithCompletion(user: String, completion: (tweets: [Tweet]?, error: NSError?) -> () ) {
        var tweets: [Tweet] = [Tweet]()
        GET("1.1/statuses/user_timeline.json", parameters: ["screen_name" : user], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("User timeline: \(response)")
            
            tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            for tweet in tweets {
                
                //println("Tweet Text: \(tweet.text), Created: \(tweet.creationDate)")
            }
            
            completion(tweets: tweets, error: nil)
            
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error receiving home timeline: \(error)")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func getMentionsTimelineWithCompletion(completion: (tweets: [Tweet]?, error: NSError?) -> () ) {
        var tweets: [Tweet] = [Tweet]()
        GET("1.1/statuses/mentions_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("Mentions timeline: \(response)")
            
            tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            for tweet in tweets {
                
                //println("Tweet Text: \(tweet.text), Created: \(tweet.creationDate)")
            }
            
            completion(tweets: tweets, error: nil)
            
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error receiving home timeline: \(error)")
                completion(tweets: nil, error: error)
        })
        
    }
    
    func postTweetWithCompletion(string: String, completion: (error: NSError?) -> ()) {
        
        var tweet: Dictionary<String, String> = ["status" : string] as Dictionary<String,String>!
        
        POST("1.1/statuses/update.json", parameters: tweet, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("Tweet Posted Successfully")
            completion(error: nil)
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Error posting new tweet")
            completion(error: error)
        }
    }
    
    func markFavoriteWithCompletion(id: Int, completion: (error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: ["id" : id], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("Favorited Successfully")
            completion(error: nil)
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Favorite Creation Failed")
            completion(error: error)
        }
        
    }
    
    func unFavoriteWithCompletion(id: Int, completion: (error: NSError?) -> ()) {
        
        POST("1.1/favorites/destroy.json", parameters: ["id" : id], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("UnFavorited Successfully")
            completion(error: nil)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Favorite Destroy Failed")
                completion(error: error)
        }
        
    }
    
    func markRetweetWithCompletion(id: Int, completion: (error: NSError?) -> ()) {
        
        POST("1.1/statuses/retweet/\(id).json", parameters: ["id" : id], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("Retweeted Successfully")
            completion(error: nil)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Retweet Failed")
                completion(error: error)
        }
        
    }
    


  
}
