//
//  InitialViewController.swift
//  Homescape
//
//  Created by David G Chopin on 5/28/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class InitialViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewVerticalCenterConstraint: NSLayoutConstraint!
    
    //Tells us if this VC is being presented for the first time
    var isFirstAppearance = true
    //Tells us if this VC is being navigated to from a session logout
    var fromLogout = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.delegate = self
        
        //Set color of buttons
        loginButton.tintColor = UIColor.secondaryColor
        signupButton.tintColor = UIColor.secondaryColor
        
        if fromLogout {
            presentElements(withAnimation: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !fromLogout {
            //See if our user is already logged in
            checkLoginStatus()
        }
    }
    
    func checkLoginStatus() {
        //If the user was previously logged in, go ahead and segue to the mapVC without making them login again
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "SkipLogin", sender: self)
        } else {
            if FBSDKAccessToken.current() != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        // ...
                        return
                    }
                    // User is signed in
                    self.performSegue(withIdentifier: "SkipLogin", sender: self)
                }
            } else if isFirstAppearance {
                
                //Only present elements if this is the first time the view controller has been presented in this session
                presentElements(withAnimation: true)
                isFirstAppearance = false
            }
            
        }
    }
    
    func presentElements(withAnimation: Bool) {
        
        //Make buttons invisible
        loginButton.isHidden = false
        signupButton.isHidden = false
        
        if withAnimation {
            
            //Calculate distance to slide up
            self.stackViewVerticalCenterConstraint.constant = (view.frame.height / 2) + (stackView.frame.height / 2)
            
            //Set alpha to 0
            loginButton.alpha = 0
            signupButton.alpha = 0
            
            //Calculate distance to slide up
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.75) {
                    self.loginButton.alpha = 1
                    self.signupButton.alpha = 1
                    
                    //Create correct vertical position for stackView
                    self.stackViewVerticalCenterConstraint.constant = (self.view.frame.height - self.navigationController!.navigationBar.frame.size.height - self.signupButton.frame.maxY - (self.stackView.frame.size.height / 2)) / 3
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            //Create correct vertical position for stackView
            self.stackViewVerticalCenterConstraint.constant = (self.view.frame.height - self.navigationController!.navigationBar.frame.size.height - self.signupButton.frame.maxY - (self.stackView.frame.size.height / 2)) / 3
        }
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController!.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let signupVC = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        navigationController!.pushViewController(signupVC, animated: true)
    }
}

extension InitialViewController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        //This tells our navigation controller the style that we want to animate our transition between view controllers
        
        let simpleOver = SimpleOver()
        simpleOver.popStyle = (operation == .pop)
        return simpleOver
    }
}
