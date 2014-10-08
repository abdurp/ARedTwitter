//
//  ProfileViewController.swift
//  ARedTwitter
//
//  Created by admin on 10/6/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    var timelineVC: UIViewController!
    
    var profPageVC: UIViewController!
    
    var mentionVC: UIViewController!
    
    var tweetDetailVC: UIViewController!
    
    var storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    @IBOutlet weak var profilePicButton: UIButton!
    @IBOutlet weak var timelineButton: UIButton!
    @IBOutlet weak var profPageButton: UIButton!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var mentionButton: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(red: 0.25, green: 0.6, blue: 1.0, alpha: 0.0)
        
        self.menuView.frame.origin.x = -134
        self.menuView.frame.origin.y = 64
        
        self.contentView.frame.origin.x = 0
        self.contentView.frame.origin.y = 64
        
        
        timelineVC = self.storyBoard.instantiateViewControllerWithIdentifier("TweetsViewController") as UIViewController
        
        profPageVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProfPageViewController") as UIViewController
        
        tweetDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("TweetDetailViewController") as UIViewController
        
        mentionVC = self.storyBoard.instantiateViewControllerWithIdentifier("MentionsViewController") as UIViewController
        
        self.activeViewController = timelineVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        
        if _currentUser!.profileImageUrl != nil {
            
            profilePicButton.setTitle(_currentUser?.name!, forState: UIControlState.Normal)
            
                profilePicView.setImageWithURL(NSURL(string: _currentUser!.profileImageUrl!))
            
        }
        
        if sender.state == .Ended {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.menuView.frame.origin.x = 0
                self.contentView.frame.origin.x = 134
            })
            
        }

    }
    
    @IBAction func onMenuButton(sender: UIButton) {
        
        if sender == timelineButton {
            self.activeViewController = timelineVC
        }
        else if sender == profPageButton || sender == profilePicButton {
            self.activeViewController = profPageVC
        }
        else if sender == mentionButton {
            self.activeViewController = mentionVC
        }
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuView.frame.origin.x = -134
            self.menuView.frame.origin.y = 64
            
            self.contentView.frame.origin.x = 0
            self.contentView.frame.origin.y = 64
            
        })
    }
    
    
    @IBAction func onPicTap(sender: UITapGestureRecognizer) {
        
        self.activeViewController = profPageVC
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.menuView.frame.origin.x = -134
            self.menuView.frame.origin.y = 64
            
            self.contentView.frame.origin.x = 0
            self.contentView.frame.origin.y = 64
            
        })
        
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
