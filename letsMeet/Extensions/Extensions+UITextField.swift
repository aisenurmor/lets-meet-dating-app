//
//  Extensions+UITextField.swift
//  letsMeet
//
//  Created by aisenur on 9.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    public convenience init(placeholder: String) {
        self.init()
        self.placeholder = placeholder
    }
}
