//
//  ProfileViewController.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/23.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    var items = []
    var user: PFUser?
    
    @IBOutlet var tableView: UITableView?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "PostCell", bundle: nil)
        self.tableView?.registerNib(nib, forCellReuseIdentifier: "PostCellIdentifier")
        
        self.tableView?.estimatedRowHeight = 100

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NetworkManager.sharedInstance.fetchPosts(self.user, completionHandler: { (objects, error) -> () in
            if let constError = error {
                // Alert the user
            } else {
                self.items = objects!
                self.tableView?.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCellIdentifier") as! PostCell
        var item = items[indexPath.row] as! PFObject
        
        cell.post = item
        return cell
    }
}
