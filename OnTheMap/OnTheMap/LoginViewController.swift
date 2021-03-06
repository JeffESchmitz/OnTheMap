//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 4/30/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet { emailTextField.delegate = self }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet { passwordTextField.delegate = self }
    }
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var accountSignUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        // just for debugging
        if _isDebugAssertConfiguration() {
            emailTextField.text = "jeffeschmitz@gmail.com"
            passwordTextField.text = ""
        }
    }
    
    @IBAction func udacityLoginButtonTapped(sender: AnyObject) {
        guard !emailTextField.text!.isEmpty,
            let userName = emailTextField.text else {
            showAlert(Constants.emailEmptyMessage)
            return
        }
        
        guard !passwordTextField.text!.isEmpty,
            let password = passwordTextField.text else {
            showAlert(Constants.passwordEmptyMessage)
            return
        }
        
        LoadingOverlay.shared.showOverlay(self.view, message: "Connecting to Udacity")
        
        Client.sharedInstance.userLogin.loginType = LoginType.Udacity
        Client.sharedInstance.udacityLogin(userName, password: password) { (result, error) in
            dispatch_async(dispatch_get_main_queue(), { 
                if let status = result as? Bool where status {
                    self.completeLogin()
                } else {
                    LoadingOverlay.shared.hideOverlayView()
                    print("error: \(error)")
                    self.showAlert(error)
                }
            })
        }
    }
    
    @IBAction func udacitySignUpTapped(sender: AnyObject) {
        let urlString = Constants.UdacityAPI.SignUpUrl
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func facebookLoginButtonTapped(sender: AnyObject) {
        
        LoadingOverlay.shared.showOverlay(self.view, message: "Connecting to Facebook")
        
        // permissions for Facebook to grant login access
        let permissions = ["public_profile", "email"]
        
        Client.sharedInstance.userLogin.loginType = LoginType.FaceBook
        Client.sharedInstance.facebookManager?.loginBehavior = FBSDKLoginBehavior.Web
        Client.sharedInstance.facebookManager?.logInWithReadPermissions(permissions, fromViewController: self, handler: { (result, error) in
            
            guard error == nil else {
                self.showAlert("Unable to login to Facebook")
                return
            }
            
            // now for the Facebook token
            if result.token != nil {
                Client.sharedInstance.facebookLogin(result.token.tokenString!, completionHandler: { (result, error) in
                    self.completeLogin()
                })
            }
            else {
                LoadingOverlay.shared.hideOverlayView()
            }
        })
        
    }
    
    private func completeLogin() {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.emailTextField.text = ""
            self.passwordTextField.text = ""

            LoadingOverlay.shared.hideOverlayView()

            // Navigate to the TabBarController
            let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as! UINavigationController
            self.presentViewController(tabBarController, animated: true, completion: nil)
        })
    }
    
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
}

//TODO: JES - 5.1.2016 - Move out to new class file, after login is working.
extension UIViewController {
    
    func showAlert(message: String! = "") {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
