//
//  DataSource.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import Foundation
import UIKit

class Store {
    private var users: [User] = []
    func getUsers(completion: @escaping([User]?) -> ()) {
        let user1 = User(userName: "Imran Khan", profileImage: "ik1")
        let user2 = User(userName: "Muhammad Aamir", profileImage: "aamir1")
        let user3 = User(userName: "Shahid Afradi", profileImage: "lala1")
        
        users.append(user1)
        users.append(user2)
        users.append(user3)
        
        if users.count != 0 {
            completion(users)
        } else {
            completion(nil)
        }
    }
    
    func getImageCollection(completion: @escaping([[UIImage]]?) -> ()) {
        let imgCollection = [
            [UIImage(named:"ik1"), UIImage(named:"ik2"), UIImage(named:"ik3"), UIImage(named:"ik4")],
            [UIImage(named:"aamir1"), UIImage(named:"aamir2"), UIImage(named:"aamir3")],
            [UIImage(named:"lala1"), UIImage(named:"lala2"), UIImage(named:"lala3"), UIImage(named:"lala4")],
        ]
        
        if imgCollection.count != 0 {
            completion(imgCollection as? [[UIImage]])
        } else {
            completion(nil)
        }
    }
    
}
