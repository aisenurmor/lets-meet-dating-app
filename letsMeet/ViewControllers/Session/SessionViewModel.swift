//
//  SessionViewModel.swift
//  letsMeet
//
//  Created by aisenur on 29.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import Firebase

class SessionViewModel {
    
    var loggingIn = Bindable<Bool>()
    var formIsValid = Bindable<Bool>()
    
    var email: String? {
        didSet {
            isValidControl()
        }
    }
    var password: String? {
        didSet {
            isValidControl()
        }
    }
    
    fileprivate func isValidControl() {
        let isValid = isValidEmail(email!) && password?.isEmpty == false
        formIsValid.value = isValid
    }
    
    func signin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        
        loggingIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            completion(err)
        }
    }
}
