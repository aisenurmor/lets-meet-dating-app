//
//  Extensions+Firestore.swift
//  letsMeet
//
//  Created by aisenur on 28.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    func getUserInformations(completion: @escaping (User?, Error?) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let informations = snapshot?.data() else {
                let err = NSError(domain: "aisenurmor.com.letsMeet", code: 400, userInfo: [NSLocalizedDescriptionKey: "User not found."])
                completion(nil, err)
                return
            }
            
            let user = User(informations: informations)
            completion(user, nil)
        }
    }
}
