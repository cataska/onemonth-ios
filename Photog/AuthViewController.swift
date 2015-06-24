//
//  AuthViewController.swift
//  Photog
//
//  Created by Lin Wen Chun on 2015/6/17.
//  Copyright (c) 2015年 Lin Wen Chun. All rights reserved.
//

import UIKit

enum AuthMode {
    case SignIn
    case SignUp
}

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    var authMode: AuthMode = .SignUp
    
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var passwordTextField: UITextField?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None
        
        var emailImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.emailTextField!.frame.size.height))
        emailImageView.image = UIImage(named: "EmailIcon")
        emailImageView.contentMode = .Center
        
        self.emailTextField?.leftView = emailImageView
        self.emailTextField?.leftViewMode = .Always
        
        var passwordImageView = UIImageView(frame: CGRectMake(0, 0, 50, self.passwordTextField!.frame.size.height))
        passwordImageView.image = UIImage(named: "PasswordIcon")
        passwordImageView.contentMode = .Center
        
        self.passwordTextField?.leftView = passwordImageView
        self.passwordTextField?.leftViewMode = .Always
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.emailTextField?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.emailTextField?.resignFirstResponder()
            self.passwordTextField?.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.passwordTextField?.resignFirstResponder()
            self.authenticate()
        }
        
        return true
    }
    
    func authenticate() {
        var email = self.emailTextField?.text
        var password = self.passwordTextField?.text
        
        if email?.isEmpty == true || password?.isEmpty == true || email?.isEmailAddress() == false {
            // alert the user
            showAlert("Please check your email address and password")
            return
        }
        
        if authMode == .SignIn {
            self.signIn(email!, password: password!)
        } else {
            self.signUp(email!, password: password!)
        }
    }
    
    func signIn(email: String, password: String) {
        PFUser.logInWithUsernameInBackground(email, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil {
                var tabBarController = TabBarController()
                self.navigationController?.pushViewController(tabBarController, animated: true)
            } else {
                println("sign in failure")
            }
        }
    }
    
    func signUp(email: String, password: String) {
        var user = PFUser()
        user.username = email
        user.email = email
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            
            if error == nil {
                // New user follow him/herself
                NetworkManager.sharedInstance.follow(user, completionHandler: {
                    (error) -> () in
                    
                    if error == nil {
                        var tabBarController = TabBarController()
                        self.navigationController?.pushViewController(tabBarController, animated: true)
                    } else {
                        println("Unable for user to follow themself")
                    }
                })
            } else {
                println("sign up failure")
            }
        }
    }    
}
