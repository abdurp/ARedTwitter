//
//  User.swift
//  ARedTwitter
//
//  Created by admin on 9/27/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var tagLine: String?
    var dictionary: NSDictionary
    
    var profileBannerUrl: String?
    var tweetsCountString: String?
    var followingCountString: String?
    var followersCountString: String?
   
    init(dictionary: NSDictionary) {
        
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
        
        profileBannerUrl = dictionary["profile_banner_url"] as? String
        tweetsCountString = String(dictionary["statuses_count"] as Int)
        followingCountString = String(dictionary["friends_count"] as Int)
        followersCountString = String(dictionary["followers_count"] as Int)
        
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
        
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if data != nil {
        
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
        
                    _currentUser = User(dictionary: dictionary)
        
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                
                NSUserDefaults.standardUserDefaults().synchronize()
                
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
             NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func logout() {
        User.currentUser = nil
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
}
