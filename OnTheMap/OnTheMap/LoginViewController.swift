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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // just for debugging
        if _isDebugAssertConfiguration() {
            emailTextField.text = "jeffeschmitz@gmail.com"
            passwordTextField.text = "PZ2-Lo2-mTA-KcE"
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
        
        Client.sharedInstance.udacityLogin(userName, password: password) { (result, error) in
            self.login(LoginType.Udacity, result: result, error: "")
        }
        
        
        //TODO: Need to evaluate something here to determine if to navigate to Tab Controller or flash "Not Logged In" alert to user
        dispatch_async(dispatch_get_main_queue()) { 
            let rootNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController") as! UINavigationController
            self.presentViewController(rootNavigationController, animated: true, completion: nil)
        }
    }
    
    private func login(loginType: LoginType, result: AnyObject, error: String) {
        
        Client.sharedInstance.userLoginType = .Udacity
        
        
        
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
    
    func showAlert(message: String = "") {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
