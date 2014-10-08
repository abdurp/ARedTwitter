//
//  TweetsViewController.swift
//  ARedTwitter
//
//  Created by admin on 10/7/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

//
//  TweetsViewController.swift
//  ATwitter
//
//  Created by admin on 9/27/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {
    
    
    @IBOutlet weak var timelineTableView: UITableView!
    
    var tweets: [Tweet]! = [Tweet]()
    var refreshControl:UIRefreshControl!
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Light)
    
    var selectedUser: User!
    
    func refresh(sender:AnyObject)
    {
        getTweets()
        self.timelineTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.textLabel.text = "Loading Tweets.."
        HUD.showInView(self.view)
        
        
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        
        getTweets()
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "reloadTweets", userInfo: nil, repeats: false)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.timelineTableView.insertSubview(refreshControl, aboveSubview: self.timelineTableView)
        
        HUD.dismissAfterDelay(4)
        
        timelineTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        //timelineTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        timelineTableView.reloadData()
    }
    
    func getTweets()
    {
        TwitterClient.sharedInstance.getTimelineWithCompletion({(tweets, error) -> () in
            
            self.tweets = tweets
        })
        
        self.timelineTableView.reloadData()
    }
    
    func reloadTweets()
    {
        self.timelineTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        User.currentUser?.logout()
    }
    
    func tweetCell(tweetCell: TweetCell, didChangeValue value: Bool) {
        var indexPath = timelineTableView.indexPathForCell(tweetCell)
        var tweet = tweets[indexPath!.row] as Tweet!
        
        if tweet != nil {

            selectedUser = tweet.user!
        
        }
        
        self.performSegueWithIdentifier("profileSegue", sender: self)
    
       
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = timelineTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.delegate = self
        
        cell.contentView.layoutSubviews()
        
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
    

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "detailSegue" {
        
            let tweetDetailVC = segue.destinationViewController as TweetDetailViewController
            var row = self.timelineTableView.indexPathForSelectedRow()?.row
            tweetDetailVC.tweet = tweets[row!]

        }
        else if segue.identifier == "profileSegue" {
            let profileVC = segue.destinationViewController as ProfPageViewController
            profileVC.user = selectedUser!
            profileVC.userScreenName = selectedUser.screenName!
        }
        
        
    }
    
    
}
