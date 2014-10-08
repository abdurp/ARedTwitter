//
//  TweetCell.swift
//  ARedTwitter
//
//  Created by admin on 9/27/14.
//  Copyright (c) 2014 abdi. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func tweetCell(tweetCell: TweetCell, didChangeValue value: Bool) -> Void
}

class TweetCell: UITableViewCell {

    
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var postedAtLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    @IBOutlet weak var replyView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!

    @IBOutlet weak var retweetView: UIImageView!
    

    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var delegate: TweetCellDelegate?
    
    var tapGR: UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tapGR = UITapGestureRecognizer(target: self, action: Selector("onTapImage")) as UITapGestureRecognizer
        tapGR.numberOfTapsRequired = 1
        
        tapGR.delegate = self
        
        profileView.addGestureRecognizer(tapGR)
        
    }
    
    func onTapImage() {
        delegate?.tweetCell(self, didChangeValue: true)
    }
    

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
