//
//  PasswordResetViewController.swift
//  FirebaseLoginSignup
//
//  Created by David G Chopin on 5/31/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit
import Firebase
import PMAlertController
import MaterialComponents

class PasswordResetViewController: UIViewController {
    
    @IBOutlet var activityIndicator: MDCActivityIndicator!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var heightFromBottomConstraint: NSLayoutConstraint!
    var passedEmailFromPreviousVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVisuals()
        
        navigationItem.title = "Password Reset"
        
        addInputAccessoryForTextFields(textFields: [emailTextField], dismissable: true, previousNextable: false)
        
        if passedEmailFromPreviousVC != nil {
            emailTextField.text = passedEmailFromPreviousVC
        }
        
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        //Animate shift of stack view up above the keyboard that is presented
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.heightFromBottomConstraint.constant = rect.height - 60
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        //Animate shift of stack view back to its original position
        UIView.animate(withDuration: 0.25) {
            self.heightFromBottomConstraint.constant = 60
            self.view.layoutIfNeeded()
        }
    }
    
    //Sets up the appearance of the buttons
    func setupVisuals() {
        //Round activity indicator
        activityIndicator.layer.cornerRadius = activityIndicator.frame.height / 2
        
        //Set activity indicator colors
        activityIndicator.cycleColors = [UIColor.secondaryColor]
        
        //Set tint color of our button
        resetButton.tintColor = UIColor.secondaryColor
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        //Check that the user doesn't have an empty email field
        if emailTextField.text!.count == 0 {
            let alertController = PMAlertController(title: "Error", description: "Enter an email to reset your password.", image: nil, style: .alert)
            alertController.alertTitle.textColor = UIColor.darkText
            let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
            ok.setTitleColor(UIColor.secondaryColor, for: .normal)
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        //Show and animate activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        Auth.auth().fetchSignInMethods(forEmail: emailTextField.text!) { (results, error) in
            //Hide activity indicator
            self.activityIndicator.isHidden = true
            
            //Check if we got results back from the submitted email
            guard let _ = results, results != nil else {
                let alertController = PMAlertController(title: "Error", description: "We couldn't find a FirebaseLoginSignup account associated with that email.", image: nil, style: .alert)
                alertController.alertTitle.textColor = UIColor.darkText
                let ok = PMAlertAction(title: "OK", style: .cancel, action: {
                    self.navigationController!.popToRootViewController(animated: true)
                })
                ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //We only want users who have non-Facebook linked accounts to be able to reset their password
            if results!.first == "password" {
                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { error in
                    if error == nil {
                        let alertController = PMAlertController(title: "Password Reset Sent", description: "Check your email to reset your FirebaseLoginSignup password.", image: nil, style: .alert)
                        alertController.alertTitle.textColor = UIColor.darkText
                        let ok = PMAlertAction(title: "OK", style: .cancel, action: {
                            self.navigationController!.popToRootViewController(animated: true)
                        })
                        ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        let alertController = PMAlertController(title: "Error occured", description: error?.localizedDescription ?? "", image: nil, style: .alert)
                        alertController.alertTitle.textColor = UIColor.darkText
                        let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
                        ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                let alertController = PMAlertController(title: "Error", description: "Only accounts that aren't linked with Facebook can reset their passwords.", image: nil, style: .alert)
                alertController.alertTitle.textColor = UIColor.darkText
                let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
                ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

