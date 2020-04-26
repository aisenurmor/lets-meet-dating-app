//
//  Validations.swift
//  letsMeet
//
//  Created by aisenur on 20.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation

public func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
