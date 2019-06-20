//
//  DataSource.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import Foundation

class DataSource {
    private var users: [User] = []
    
    var user1 = User(userName: "Muhammad Aamir", profileImage: "profile1")
    var user2 = User(userName: "Muhammad Iqbal", profileImage: "profile2")
    var user3 = User(userName: "Maya Ali", profileImage: "profile3")
    var user4 = User(userName: "Rashid Khan", profileImage: "profile4")
    
    
    func getUsers(completion: @escaping([User]?) -> ()) {
        let user1 = User(userName: "Muhammad Aamir", profileImage: "profile1")
        let user2 = User(userName: "Muhammad Iqbal", profileImage: "profile2")
        let user3 = User(userName: "Maya Ali", profileImage: "profile3")
        let user4 = User(userName: "Rashid Khan", profileImage: "profile4")
        
        users.append(user1)
        users.append(user2)
        users.append(user3)
        users.append(user4)
        
        if users.count != 0 {
            completion(users)
        } else {
            completion(nil)
        }
    }
    
}
