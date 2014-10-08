//
//  ProfPageViewController.swift
//  ARedTwitter
//
//  Created by admin on 10/7/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

class ProfPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var profileTableView: UITableView!
    
    var tweets: [Tweet]! = [Tweet]()
    var refreshControl:UIRefreshControl!
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Light)
    
    var userScreenName: String!
    var user: User!


    override func viewDidLoad() {
        super.viewDidLoad()

        HUD.textLabel.text = "Loading Tweets.."
        HUD.showInView(self.view)
        HUD.dismissAfterDelay(4)
        
        if user == nil {
            user = User.currentUser
        }
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        getTweets()
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "reloadTweets", userInfo: nil, repeats: false)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.profileTableView.insertSubview(refreshControl, aboveSubview: self.profileTableView)

        
        profileTableView.rowHeight = 127
        
    }
    
    func refresh(sender:AnyObject)
    {
        getTweets()
        self.profileTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func getTweets()
    {
        if userScreenName == nil {
            userScreenName = User.currentUser?.screenName
        }
        TwitterClient.sharedInstance.getUserTimelineWithCompletion(userScreenName!, {(tweets, error) -> () in
            
            self.tweets = tweets
        })
        
        self.profileTableView.reloadData()
    }
    
    func reloadTweets()
    {
        self.profileTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        profileTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tweets?.count) ?? 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //var bannerImageView: UIImageView! = UIImageView(image: UIImage(named:"watermarked_Cover-220.jpg"))
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0.0)
        var blank = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        var bannerImageView : UIImageView! = UIImageView(image: blank)
        
        if user != nil {
        //if User.currentUser!.profileBannerUrl != nil {
        
            bannerImageView.setImageWithURL(NSURL(string: user!.profileBannerUrl!))
 
            bannerImageView.frame = CGRectMake(0,64,320,100)
            
            var profilePicImageView: UIImageView! = UIImageView(image: blank)
            profilePicImageView.setImageWithURL(NSURL(string: user!.profileImageUrl!))
            profilePicImageView.frame = CGRectMake(135, 7, 60, 60)
            
            var nameLabel: UILabel! = UILabel(frame: CGRect(x: 110, y: 74, width: 200, height: 10))
            nameLabel.font = UIFont.systemFontOfSize(14)
            nameLabel.textColor = UIColor.whiteColor()
            nameLabel.text = user!.name!
            
            var handleLabel: UILabel! = UILabel(frame: CGRect(x: 135, y: 88, width: 200, height: 10))
            handleLabel.font = UIFont.systemFontOfSize(11)
            handleLabel.textColor = UIColor.whiteColor()
            handleLabel.text = "@\(user!.screenName!)"
            
            
            bannerImageView.addSubview(profilePicImageView)
            bannerImageView.addSubview(nameLabel)
            bannerImageView.addSubview(handleLabel)
        
            self.profileTableView.sectionHeaderHeight = 100
        }
        
        return bannerImageView!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            profileTableView.rowHeight = 40
            
            var cell = profileTableView.dequeueReusableCellWithIdentifier("CountCell") as CountCell
            
            if tweets?.count != 0 {
                cell.countLabel!.text = "\(user.tweetsCountString!) Tweets    \(user.followingCountString!) Following    \(user.followersCountString!) Followers"
            }
            
            return cell

        }
        else {
            
            profileTableView.rowHeight = 127
            
            var cell = profileTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
            
            //cell.contentView.layoutSubviews()
            
            if tweets?.count != 0 {
                var tweet = tweets[indexPath.row] as Tweet!
                
                if tweet != nil {
                    cell.nameLabel.text = tweet.user?.name
                    cell.handleLabel.text = "@\(tweet.user!.screenName!)"
                    cell.tweetTextLabel.text = tweet.text
                    cell.postedAtLabel.text = tweet.creationDate?.timeAgo()
                    
                    if tweet.user?.profileImageUrl != nil {
                        cell.profileView.setImageWithURL(NSURL(string: tweet.user!.profileImageUrl!))
                    }
                    
                    cell.replyView.setImageWithURL(NSURL(string: replyImageURL))
                    cell.retweetView.setImageWithURL(NSURL(string: retweetImageURL))
                    if tweet.retweetCount == "0" {
                        cell.retweetCountLabel.hidden = true
                    }
                    else {
                        cell.retweetCountLabel.hidden = false
                        cell.retweetCountLabel.text = tweet.retweetCount
                        
                    }
                    
                    cell.favoriteImageView.setImageWithURL(NSURL(string: favoriteImageURL))
                    if tweet.favoriteCount == "0" {
                        cell.favoriteCountLabel.hidden = true
                    }
                    else {
                        cell.favoriteCountLabel.hidden = false
                        cell.favoriteCountLabel.text = tweet.favoriteCount
                    }
                    
                }
                
            }
            return cell
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
