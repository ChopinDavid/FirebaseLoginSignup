//
//  OnboardBgViewController.swift
//  FirebaseLoginSignup
//
//  Created by David G Chopin on 5/27/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import UIKit

class OnboardBgViewController: UIViewController {

    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var logoVerticalCenterConstraint: NSLayoutConstraint!
    
    //Tells us if this VC is being navigated to from a session logout
    var fromLogout = false
    
    override func viewDidLayoutSubviews() {
        if fromLogout {
            presentElements(withAnimation: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !fromLogout {
            presentElements(withAnimation: true)
        }
    }
    
    func presentElements(withAnimation: Bool) {
        //Calculate distance to slide up
        let halfViewHeight = view.frame.height/2
        let halfLogoHeight = logoImageView.frame.height/2
        let difference = -(halfViewHeight - halfLogoHeight - view.safeAreaInsets.top - 80)
        if withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                UIView.animate(withDuration: 0.75) {
                    self.logoVerticalCenterConstraint.constant = difference
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            self.logoVerticalCenterConstraint.constant = difference
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if fromLogout {
            let destinationNavigationController = segue.destination as! UINavigationController
            let initialVC = destinationNavigationController.topViewController as! InitialViewController
            initialVC.fromLogout = true
        }
    }
}

