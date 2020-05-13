//
//  Matching.swift
//  letsMeet
//
//  Created by aisenur on 13.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation

struct Matching {
    let username: String
    let profileImageURL: String
    let userId: String
    
    init(data: [String: Any]) {
        self.username = data["nameSurname"] as? String ?? ""
        self.profileImageURL = data["imageUrl"] as? String ?? ""
        self.userId = data["uuid"] as? String ?? ""
    }
}
