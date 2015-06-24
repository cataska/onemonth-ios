//
//  TabBarController.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/17.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        var feedViewController = FeedViewController(nibName: "FeedViewController", bundle: nil)
        
        var profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileViewController.user = PFUser.currentUser()
        
        var searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        
        var cameraViewController = UIViewController()
        cameraViewController.view.backgroundColor = UIColor.purpleColor()
        
        var viewControllers = [feedViewController, profileViewController, searchViewController, cameraViewController]
        self.setViewControllers(viewControllers, animated: true)
        
        var imageNames = ["FeedIcon", "ProfileIcon", "SearchIcon", "CameraIcon"]
        
        let tabItems = self.tabBar.items as! [UITabBarItem]
        for (index, value) in enumerate(tabItems) {
            var imageName = imageNames[index]
            value.image = UIImage(named: imageName)
            value.imageInsets = UIEdgeInsetsMake(5.0, 0, -5.0, 0)
        }
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.hidesBackButton = true
        self.tabBar.translucent = false
        
        self.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Done, target: self, action: "didTapSignOut:")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Photog"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapSignOut(sender: AnyObject) {
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        var cameraViewController = self.viewControllers![3] as! UIViewController
        if viewController == cameraViewController {
            self.showCamera()
            return false
        }
        
        return true
    }
    
    func showCamera() {
        var sourceType: UIImagePickerControllerSourceType = .Camera
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            self.showAlert("Camera is not available")
            return
        }
        
        var viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        println(image)
        
        var targetWidth = UIScreen.mainScreen().scale * UIScreen.mainScreen().bounds.size.width
        var resizedImage = image.resize(targetWidth)
        
        println(resizedImage)
        
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
            NetworkManager.sharedInstance.postImage(resizedImage, completionHandler: {
                (error) -> () in
                
                if let constError = error {
                    self.showAlert(constError.localizedDescription)
                }
            })
        })
    }
}
