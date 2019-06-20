//
//  User.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import Foundation

class User {
    var userName: String
    var profileImage: String
    
    init(userName: String, profileImage: String) {
        self.userName = userName
        self.profileImage = profileImage
    }
}
