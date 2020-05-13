//
//  Message.swift
//  letsMeet
//
//  Created by aisenur on 13.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let message: String
    let senderId: String
    let receiverId: String
    let timestamp: Timestamp
    
    let isCurrentUserMessage: Bool
    
    init(data: [String: Any]) {
        self.message = data["message"] as? String ?? ""
        self.senderId = data["senderId"] as? String ?? ""
        self.receiverId = data["receiverId"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isCurrentUserMessage = Auth.auth().currentUser?.uid == self.senderId
    }
}
