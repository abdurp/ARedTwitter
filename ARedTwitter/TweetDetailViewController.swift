//
//  TweetDetailViewController.swift
//  ATwitter
//
//  Created by admin on 9/30/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var  tweet: Tweet!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = tweet?.user?.name
        screenNameLabel.text = "@\(tweet!.user!.screenName!)"
        
        if tweet?.user?.profileImageUrl != nil {
            profileView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
        }
        
        tweetTextLabel.text = tweet?.text
        
        var result: NSComparisonResult
        
        if tweet?.text?.rangeOfString("RT @") != nil {
            retweetedLabel.hidden = false
             retweetedLabel.text = "\(tweet!.user!.name!) retweeted"
        }
        
        
        countLabel.text = "\(tweet!.retweetCount!) RETWEETS    \(tweet!.favoriteCount!) FAVORITES"
    
        if tweet.favorited == false {
            favoriteButton!.imageView?.setImageWithURL(NSURL(string: favoriteImageURL))
        } else {
            favoriteButton!.imageView?.setImageWithURL(NSURL(string: favoriteOnImageURL))
        }
        
        if tweet.retweeted == false {
            retweetButton!.imageView?.setImageWithURL(NSURL(string: retweetImageURL))
        }
        else {
            retweetButton!.imageView?.setImageWithURL(NSURL(string: retweetOnImageURL))
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "replySegue" || segue.identifier == "replyButtonSegue" {
//            let composeVC = segue.destinationViewController.viewControllers![0] as ComposeViewController
//            composeVC.replyUserName = tweet!.user!.screenName
//        }
//    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        var newFavCount = tweet!.favoriteCount!.toInt()
        
        if tweet.favorited == false {
            tweet.markFavorite(tweet.id!)
            favoriteButton.imageView?.setImageWithURL(NSURL(string: favoriteOnImageURL))
            tweet.favorited = true
            newFavCount = newFavCount! + 1
        } else {
            tweet.unFavorite(tweet.id!)
            favoriteButton.imageView?.setImageWithURL(NSURL(string: favoriteImageURL))
            tweet.favorited = false
            newFavCount = newFavCount! - 1
        }
        tweet!.favoriteCount! = String(newFavCount!)
        countLabel.text = "\(tweet!.retweetCount!) RETWEETS    \(tweet!.favoriteCount!) FAVORITES"
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if tweet.retweeted == false {
            tweet.markRetweeted(tweet.id!)
            tweet.retweeted = true
            retweetButton!.imageView?.setImageWithURL(NSURL(string: retweetOnImageURL))
            
            var newRetweetCount = tweet!.retweetCount!.toInt()
            newRetweetCount = newRetweetCount! + 1
            tweet!.retweetCount! = String(newRetweetCount!)
            countLabel.text = "\(tweet!.retweetCount!) RETWEETS    \(tweet!.favoriteCount!) FAVORITES"
        }

    }



}
