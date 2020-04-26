//
//  ProfileCell.swift
//  letsMeet
//
//  Created by aisenur on 25.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    class ProfileTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return .init(width: 0, height: 45)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 15, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 15, dy: 0)
        }
    }
    
    let textField: UITextField = {
        let txt = ProfileTextField()
        txt.placeholder = "Yaşınızı giriniz"
        txt.autocorrectionType = .no
        txt.autocapitalizationType = .sentences
        
        return txt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
