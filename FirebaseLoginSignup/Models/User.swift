//
//  User.swift
//  Homescape
//
//  Created by David G Chopin on 5/29/19.
//  Copyright © 2019 David G Chopin. All rights reserved.
//

import Foundation

class User {
    var email: String
    var name: String
    var password: String?
    var photoUrl: String?
    
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }
    
    init(email: String, name: String, password: String) {
        self.email = email
        self.password = password
        self.name = name
    }
}
