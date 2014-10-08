//
//  MentionsViewController.swift
//  ARedTwitter
//
//  Created by admin on 10/7/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mentionsTableView: UITableView!
    
    
    var mentions: [Tweet]! = [Tweet]()
    var refreshControl:UIRefreshControl!
    var HUD = JGProgressHUD(style: JGProgressHUDStyle.Light)
    
    var selectedUser: User!
    
    func refresh(sender:AnyObject)
    {
        getMentions()
        self.mentionsTableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HUD.textLabel.text = "Loading Tweets.."
        HUD.showInView(self.view)
        
        
        mentionsTableView.delegate = self
        mentionsTableView.dataSource = self
        
        getMentions()
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "reloadMentions", userInfo: nil, repeats: false)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.mentionsTableView.insertSubview(refreshControl, aboveSubview: self.mentionsTableView)
        
        HUD.dismissAfterDelay(4)
        
        mentionsTableView.estimatedRowHeight = UITableViewAutomaticDimension
        
        //timelineTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mentionsTableView.reloadData()
    }
    
    func getMentions()
    {
        TwitterClient.sharedInstance.getMentionsTimelineWithCompletion({(tweets, error) -> () in
            
            self.mentions = tweets
        })
        
        self.mentionsTableView.reloadData()
    }
    
    func reloadMentions()
    {
        self.mentionsTableView.reloadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = mentionsTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        
        cell.contentView.layoutSubviews()
        
        mentionsTableView.rowHeight = 127
        
        if mentions?.count != 0 {
            var mention = mentions[indexPath.row] as Tweet!
            
            if mention != nil {
                
                cell.nameLabel.text = mention.user?.name
                cell.handleLabel.text = "@\(mention.user!.screenName!)"
                cell.tweetTextLabel.text = mention.text
                cell.postedAtLabel.text = mention.creationDate?.timeAgo()
                
                if mention.user?.profileImageUrl != nil {
                    cell.profileView.setImageWithURL(NSURL(string: mention.user!.profileImageUrl!))
                }

                
                cell.replyView.setImageWithURL(NSURL(string: replyImageURL))
                cell.retweetView.setImageWithURL(NSURL(string: retweetImageURL))
                if mention.retweetCount == "0" {
                    cell.retweetCountLabel.hidden = true
                }
                else {
                    cell.retweetCountLabel.hidden = false
                    cell.retweetCountLabel.text = mention.retweetCount
                    
                }
                
                cell.favoriteImageView.setImageWithURL(NSURL(string: favoriteImageURL))
                if mention.favoriteCount == "0" {
                    cell.favoriteCountLabel.hidden = true
                }
                else {
                    cell.favoriteCountLabel.hidden = false
                    cell.favoriteCountLabel.text = mention.favoriteCount
                }

                
                
            }
        }
        
        return cell
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
