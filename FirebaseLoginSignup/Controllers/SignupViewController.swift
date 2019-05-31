//
//  SignupViewController.swift
//  FirebaseLoginSignup
//
//  Created by David G Chopin on 5/29/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
import MaterialComponents
import PMAlertController

class SignupViewController: UIViewController {
    
    @IBOutlet var activityIndicator: MDCActivityIndicator!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordConfirmTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var facebookButton: FBSDKLoginButton!
    @IBOutlet var stackViewVerticalConstraint: NSLayoutConstraint!
    
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation item title
        self.navigationItem.title = "Signup"
        
        //Setup the activity indicator
        activityIndicator.layer.cornerRadius = activityIndicator.frame.width/2
        activityIndicator.cycleColors = [UIColor.secondaryColor]
        
        //Set the facebookButton's delegate
        facebookButton.delegate = self
        
        //Allow us to get the profile email when requesting facebook permission
        facebookButton.readPermissions = ["email"]
        
        //Set color of our button
        nextButton.tintColor = UIColor.secondaryColor
        
        //Create correct vertical position for stackView
        stackViewVerticalConstraint.constant = (view.frame.height - navigationController!.navigationBar.frame.size.height - facebookButton.frame.maxY - (stackView.frame.size.height / 2)) / 2
        
        //Add toolbars to the textFields
        addInputAccessoryForTextFields(textFields: [emailTextField, passwordTextField, passwordConfirmTextField, nameTextField], dismissable: true, previousNextable: true)
        
        //Set delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
        nameTextField.delegate = self
        
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector (keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                switch self.activeTextField{
                case self.emailTextField:
                    self.stackViewVerticalConstraint.constant = self.view.frame.height - rect.height - (self.view.frame.height / 2) + 101
                case self.passwordTextField:
                    self.stackViewVerticalConstraint.constant = self.view.frame.height - rect.height - (self.view.frame.height / 2) + 31
                case self.passwordConfirmTextField:
                    self.stackViewVerticalConstraint.constant = self.view.frame.height - rect.height - (self.view.frame.height / 2) - 39
                case self.nameTextField:
                    self.stackViewVerticalConstraint.constant = self.view.frame.height - rect.height - (self.view.frame.height / 2) - 109
                default:
                    break
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        activeTextField = nil
        
        //Reset constant for stack view's vertical constraint
        UIView.animate(withDuration: 0.25) {
            self.stackViewVerticalConstraint.constant = (self.view.frame.height - self.navigationController!.navigationBar.frame.size.height - self.facebookButton.frame.maxY - (self.stackView.frame.size.height / 2)) / 2
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        //Confirm all fields are filled
        if emailTextField.text!.count > 0, passwordTextField.text!.count > 0, passwordConfirmTextField.text!.count > 0, nameTextField.text!.count > 0 {
            if passwordTextField.text != passwordConfirmTextField.text {
                let alertController = PMAlertController(title: "Error", description: "Make sure your password confirmation matches", image: nil, style: .alert)
                alertController.alertTitle.textColor = UIColor.darkText
                let ok = PMAlertAction(title: "OK", style: .cancel)
                ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                alertController.addAction(ok)
                present(alertController, animated: true, completion: nil)
            } else {
                //Instantiate photoUploadVC
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                let photoUploadVC = storyboard.instantiateViewController(withIdentifier: "PhotoUploadViewController") as! PhotoUploadViewController
                
                //Add user to photoUploadVC
                let user = User(email: emailTextField.text!, name: nameTextField.text!, password: passwordTextField.text!)
                photoUploadVC.FirebaseLoginSignupUser = user
                
                //Push photoUploadVC
                navigationController!.pushViewController(photoUploadVC, animated: true)
            }
        } else {
            let alertController = PMAlertController(title: "Error", description: "Make sure all fields are filled out", image: nil, style: .alert)
            alertController.alertTitle.textColor = UIColor.darkText
            let ok = PMAlertAction(title: "OK", style: .cancel)
            ok.setTitleColor(UIColor.secondaryColor, for: .normal)
            alertController.addAction(ok)
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension SignupViewController: FBSDKLoginButtonDelegate {
    
    //Delegate method for when facebook button is pressed
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        //Bring up activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        let loginResult = result
        if let error = error {
            print(error.localizedDescription)
            return
        }
        //If the request wasn't cancelled...
        if !result.isCancelled {
            //Request the user's id, name, first name, last name, email, and 480x480 px profile picture
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.width(480).height(480)"])
            request?.start(completionHandler: { (connection, result, error) in
                guard let userInfo = result as? [String: Any] else { return } //handle the error
                
                //Check if there is already an account in our Firebase associated with the facebook account's email
                Auth.auth().fetchProviders(forEmail: userInfo["email"] as! String, completion: {
                    (providers, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        
                    } else if let providers = providers {
                        //If providers are returned, and they aren't facebook related, this means that there is already an account associated with this email
                        if providers.first != "facebook.com" {
                            let alertController = PMAlertController(title: "Email already in use.", description: "The email address linked with this Facebook account is already being used by an existing user.", image: nil, style: .alert)
                            alertController.alertTitle.textColor = UIColor.darkText
                            let ok = PMAlertAction(title: "Ok", style: .cancel, action: nil)
                            ok.setTitleColor(UIColor.secondaryColor, for: .normal)
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                            
                            //Hide activity indicator
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            self.view.isUserInteractionEnabled = true
                        } else {
                            //if the providers are related to facebook, then sign in using the facebook info
                            let credential = FacebookAuthProvider.credential(withAccessToken: loginResult?.token.tokenString ?? "")
                            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                                if error == nil {
                                    //Segue to the mapViewController if no error
                                    self.performSegue(withIdentifier: "signupToHome", sender: self)
                                    UIApplication.shared.registerForRemoteNotifications()
                                } else {
                                    print("error:", error)
                                }
                            })
                        }
                    } else {
                        //If no providers are returned, then we can create an account using the facebook info provided
                        self.createAcctWithFBCredentials(userInfo: userInfo)
                    }
                })
            })
        }
        
    }
    
    //This function passes in facebook credentials from the login result and signs into Firebase with the facebook data
    func createAcctWithFBCredentials(userInfo: [String:Any]) {
        
        //Create credential from the access token
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        //Sign into firebase with this credential
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                return
            }
            
            //The url is nested 3 layers deep into the result so it's pretty messy
            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                
                
                //Download image from imageURL
                let user = Auth.auth().currentUser
                print(imageURL)
                let task = URLSession.shared.dataTask(with: URL(string: imageURL)!) {(data, response, error) in
                    
                    let picture = UIImage(data: data!)!
                    self.uploadImage(image: picture, userid: (user?.uid)!, completion: { (url) in
                        
                        Database.database().reference().child("Users").child(user!.uid).updateChildValues(["email" : userInfo["email"] ?? "unknown email","id" : Auth.auth().currentUser!.uid,"photoUrl" : url,"name": (userInfo["name"] as! String)])
                        if let user = user {
                            let changeRequest = user.createProfileChangeRequest()
                            //Update our user's display name in firebase to their facebook name
                            changeRequest.displayName = (userInfo["name"] as! String)
                            //Update our user's photoURL in firebase to the user's profile pic
                            changeRequest.photoURL =
                                URL(string: url)
                            
                            //Commit these changes
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    // An error happened.
                                } else {
                                    // Profile updated.
                                    // User is signed in
                                    
                                    //Update our user's email in firebase to their facebook email
                                    user.updateEmail(to: userInfo["email"] as! String, completion: { (error) in
                                        self.performSegue(withIdentifier: "loginToHome", sender: self)
                                        UIApplication.shared.registerForRemoteNotifications()
                                    })
                                }
                            }
                        }
                    })
                    
                }
                task.resume()
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        //Simply here to conform to the FBSDKLoginButtonDelegate protocol; will never actually be called
    }
    
    //This function takes an image and user id...
    func uploadImage(image: UIImage, userid: String, completion: @escaping (String)->Void) {
        //... creates data from the image...
        var data = NSData()
        // data = UIImageJPEGRepresentation(image, 0.8)! as NSData
        data = image.jpegData(compressionQuality: 0.8)! as! NSData
        //...sets the upload path
        let filePath = "\(userid)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference().child(filePath)
        storageRef.putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                storageRef.downloadURL(completion: { (url, error) in
                    //Returns the url string to the newly uploaded image so that we can set the user's photoURL database property to this string
                    completion((url?.absoluteString)!)
                })
            }
        }
    }
}

extension SignupViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case emailTextField:
            activeTextField = emailTextField
        case passwordTextField:
            activeTextField = passwordTextField
        case passwordConfirmTextField:
            activeTextField = passwordConfirmTextField
        case nameTextField:
            activeTextField = nameTextField
        default:
            break
        }
    }
}
