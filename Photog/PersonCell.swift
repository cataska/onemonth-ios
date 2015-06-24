//
//  PersonCell.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/21.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {

    @IBOutlet var followButton: UIButton?
    
    var isFollowing: Bool?
    
    var user: PFUser? {
        didSet {
            self.configure()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isFollowing = false
        self.followButton?.hidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.isFollowing = false
        self.followButton?.hidden = true
        self.textLabel?.text = ""
        self.user = nil
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        if let constUser = user {
            self.textLabel?.text = constUser.username
            
            // are we following this person?
            
            NetworkManager.sharedInstance.isFollowing(constUser, completionHandler: {
                (isFollowing, error) -> () in
                
                if error != nil {
                    // Alert the user
                } else {
                    self.isFollowing = isFollowing
                    
                    if isFollowing == true {
                        var image = UIImage(named: "UnfollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    } else {
                        var image = UIImage(named: "FollowButton")
                        self.followButton?.setImage(image, forState: .Normal)
                    }
                    self.followButton?.hidden = false                    
                }
            })
            // if so: configure the button to unfollow
            
            // else: configure the button to follow
        }
    }
    
    @IBAction func didTapFollow(sender: UIButton) {
        self.followButton?.enabled = false
        
        var newValue = !(self.isFollowing == true)
        NetworkManager.sharedInstance.updateFollowValue(newValue, user: user) {
            (error) -> () in
            
            self.followButton?.enabled = true
            
            var image = (newValue == true) ? UIImage(named: "UnfollowButton") : UIImage(named: "FollowButton")
            self.followButton?.setImage(image, forState: .Normal)
            self.isFollowing = newValue
        }
        
//        if self.isFollowing == true {
//            // Unfollow
//            NetworkManager.sharedInstance.unfollow(self.user, completionHandler: { (error) -> () in
//                self.followButton?.enabled = true
//
//                if let constError = error {
//                    println(error)
//                } else {
//                    var image = UIImage(named: "FollowButton")
//                    self.followButton?.setImage(image, forState: .Normal)
//                    self.isFollowing = false
//                }
//            })
//        } else {
//            // Follow
//            NetworkManager.sharedInstance.follow(self.user, completionHandler: { (error) -> () in
//                self.followButton?.enabled = true
//
//                if let constError = error {
//                    println(error)
//                } else {
//                    var image = UIImage(named: "UnfollowButton")
//                    self.followButton?.setImage(image, forState: .Normal)
//                    self.isFollowing = true
//                }
//            })
//        }
    }
}
