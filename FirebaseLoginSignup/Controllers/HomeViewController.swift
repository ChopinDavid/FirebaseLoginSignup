//
//  HomeViewController.swift
//  FirebaseLoginSignup
//
//  Created by David G Chopin on 5/31/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var profilePicImageView: UIImageView!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the tint color of our button
        logoutButton.tintColor = UIColor.secondaryColor
        
        //Round profile pic image view and add border
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.height / 2
        profilePicImageView.layer.borderWidth = 1
        profilePicImageView.layer.borderColor = UIColor.secondaryColor.cgColor
        
        //Populate view controller with Firebase Auth data on the current user
        nameLabel.text = Auth.auth().currentUser!.displayName!
        emailLabel.text = Auth.auth().currentUser!.email!
        profilePicImageView.sd_setImage(with: Auth.auth().currentUser!.photoURL!, placeholderImage: UIImage(named: "profile"), options: [], completed: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        
        //Upon logout, we get rid of our current facebook user
        FBSDKAccessToken.setCurrent(nil)
        
        do {
            //And sign out of firebase
            try Auth.auth().signOut()
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        performSegue(withIdentifier: "SegueToLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? OnboardBgViewController {
            destinationVC.fromLogout = true
        }
    }
}
