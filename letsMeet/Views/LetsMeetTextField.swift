//
//  LetsMeetTextField.swift
//  letsMeet
//
//  Created by aisenur on 18.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class LetsMeetTextField: UITextField {
    
    var padding: CGFloat
    
    init(padding: CGFloat, placeholder: String) {
        self.padding = padding
        
        super.init(frame: .zero)
        
        self.layer.cornerRadius = 5
        self.placeholder = placeholder
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Placeholderlar için padding
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    //Textinputta düzenleme yapma durumunda padding
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 50)
    }
}
