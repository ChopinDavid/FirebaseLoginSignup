//
//  PhotoUploadViewController.swift
//  FirebaseLoginSignup
//
//  Created by David G Chopin on 5/29/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import MaterialComponents
import PMAlertController

class PhotoUploadViewController: UIViewController {
    
    @IBOutlet var activityIndicator: MDCActivityIndicator!
    @IBOutlet var containingView: UIView!
    @IBOutlet var profilePicButton: UIButton!
    @IBOutlet var pencilImageView: UIImageView!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var containingViewVerticalConstraint: NSLayoutConstraint!
    
    var FirebaseLoginSignupUser: User!
    
    //Create our image picker
    var imagePicker = UIImagePickerController()
    
    //Boolean telling us if the photo changed (if it hasn't, then we won't uplaod an image to Firebase Storage)
    var photoChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set navigation item title
        self.navigationItem.title = "Choose a Profile Picture"
        
        //Set activity indicator colors
        activityIndicator.cycleColors = [UIColor.secondaryColor]
        
        //Set the tint color of our button
        signupButton.tintColor = UIColor.secondaryColor
        
        //Style profilePictureButton
        profilePicButton.layer.cornerRadius = profilePicButton.frame.width/2
        profilePicButton.layer.borderColor = UIColor.secondaryColor.cgColor
        profilePicButton.layer.borderWidth = 1
        
        //Setup activityIndicator
        activityIndicator.layer.cornerRadius = activityIndicator.frame.width/2
        
        //Set imagePicker delegate
        imagePicker.delegate = self
        
        //Create correct vertical position for stackView
        containingViewVerticalConstraint.constant = (view.frame.height - navigationController!.navigationBar.frame.size.height - signupButton.frame.maxY - (containingView.frame.size.height / 2)) / 2
        
        //Round the pencilImageView
        pencilImageView.layer.cornerRadius = pencilImageView.frame.height / 2
    }
    @IBAction func profilePicButtonPressed(_ sender: Any) {
        let camera = UIImage(named: "camera")!.image(withTintColor: UIColor.secondaryColor)
        let alertController = PMAlertController(title: "Import from camera roll or take a picture?", description: "", image: camera, style: .alert)
        alertController.alertTitle.textColor = UIColor.darkText
        let importPic = PMAlertAction(title: "Import", style: .default) {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        importPic.setTitleColor(UIColor.secondaryColor, for: .normal)
        alertController.addAction(importPic)
        
        let newPic = PMAlertAction(title: "New Picture", style: .default) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        newPic.setTitleColor(UIColor.secondaryColor, for: .normal)
        alertController.addAction(newPic)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //This function takes an image and user id...
    func uploadImage(image: UIImage, userid: String, completion: @escaping (String)->Void) {
        //... creates data from the image...
        var data = NSData()
        data = image.jpegData(compressionQuality: 0.8)! as! NSData
        //...sets the upload path
        let filePath = "\(userid)" // path where you wanted to store img in storage
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        let storageRef = Storage.storage().reference().child(filePath)
        storageRef.putData(data as Data, metadata: metaData) {(metaData,error) in
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
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        //When the signup button is pressed, we have to take our email and password passed to us from the previous VC...
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        //...and create a firebase user with those credentials
        Auth.auth().createUser(withEmail: FirebaseLoginSignupUser.email, password: FirebaseLoginSignupUser.password!) { (user, error) in
            if error == nil {
                
                if let firebaseUser = Auth.auth().currentUser {
                    let changeRequest = firebaseUser.createProfileChangeRequest()
                    if self.photoChanged {
                        
                        //If the user selected a personal profile picture, then we need to upload it to our database
                        self.uploadImage(image: self.profilePicButton.imageView!.image!, userid: firebaseUser.uid, completion: { urlString in Database.database().reference().child("Users").child(firebaseUser.uid).updateChildValues(["email" : self.FirebaseLoginSignupUser.email,"photoUrl" : urlString,"name": self.FirebaseLoginSignupUser.name])
                            
                            
                            //Set the user's photoURL as the url of the photo we just uplaoded
                            changeRequest.photoURL = URL(string: urlString)
                            changeRequest.displayName = self.FirebaseLoginSignupUser.name
                            
                            //Commit these changes
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    // An error happened.
                                    let alertController = PMAlertController(title: "Error", description: error.localizedDescription, image: nil,  style: .alert)
                                    let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
                                    
                                    alertController.addAction(ok)
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    //Upon completion, we simply segue to the mapVC
                                    self.performSegue(withIdentifier: "photoUploadToHome", sender: self)
                                    //set this image's data as "profilePicData" in userDefaults
                                    let imageData = self.profilePicButton.imageView!.image!.jpeg(.highest)
                                    UserDefaults.standard.setValue(imageData, forKey: "profilePicData")
                                    
                                    UIApplication.shared.registerForRemoteNotifications()
                                }
                            }
                        })
                    } else {
                        Database.database().reference().child("Users").child(firebaseUser.uid).updateChildValues(["email" : self.FirebaseLoginSignupUser.email,"photoUrl" : "nil","name": self.FirebaseLoginSignupUser.name])
                        changeRequest.photoURL = URL(string: "nil")
                        changeRequest.displayName = self.FirebaseLoginSignupUser.name
                        changeRequest.commitChanges { error in
                            if let error = error {
                                // An error happened.
                                let alertController = PMAlertController(title: "Error", description: error.localizedDescription, image: nil, style: .alert)
                                let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
                                
                                alertController.addAction(ok)
                                self.present(alertController, animated: true, completion: nil)
                            } else {
                                self.performSegue(withIdentifier: "photoUploadToHome", sender: self)
                                UIApplication.shared.registerForRemoteNotifications()
                            }
                        }
                    }
                }
            } else {
                //If there is an error signing up (i.e. the email is already taken) then present said error to the user
                let alertController = PMAlertController(title: "Error", description: (error?.localizedDescription)!, image: nil, style: .alert)
                let ok = PMAlertAction(title: "OK", style: .cancel, action: nil)
                
                alertController.addAction(ok)
                self.present(alertController, animated: true, completion: nil)
                self.activityIndicator.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}

extension PhotoUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image =  info[.editedImage] as? UIImage
        
        self.profilePicButton.setImage(image, for: .normal)
        dismiss(animated: true) {
            self.photoChanged = true
        }
    }
}
