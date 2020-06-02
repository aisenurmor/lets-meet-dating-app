//
//  MessageCell.swift
//  letsMeet
//
//  Created by aisenur on 14.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class MessageCell: ListCell<Message> {
    
    let messageContainer = UIView(backgroundColor: #colorLiteral(red: 0.941651593, green: 0.941651593, blue: 0.941651593, alpha: 1))
    let txtMessage: UITextView = {
        let txt = UITextView()
        txt.backgroundColor = .clear
        txt.font = .systemFont(ofSize: 20)
        txt.isScrollEnabled = false
        txt.isEditable = false
        
        return txt
    }()
    
    override var data: Message! {
        didSet {
            txtMessage.text = data.message
            
            if data.isCurrentUserMessage {
                messageConstraint.trailing?.isActive = true
                messageConstraint.leading?.isActive = false
                messageContainer.backgroundColor = #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1)
                txtMessage.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                
            } else {
                messageConstraint.trailing?.isActive = false
                messageConstraint.leading?.isActive = true
                messageContainer.backgroundColor = #colorLiteral(red: 0.9469061932, green: 0.9469061932, blue: 0.9469061932, alpha: 1)
                txtMessage.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
    
    var messageConstraint: AnchorConstraints!
    override func creatViews() {
        super.creatViews()
        
        addSubview(messageContainer)
        messageContainer.layer.cornerRadius = 10
        
        messageConstraint = messageContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        messageConstraint.leading?.constant = 6
        messageConstraint.trailing?.constant = -20
        
        messageContainer.widthAnchor.constraint(lessThanOrEqualToConstant: frame.width*0.7).isActive = true
        messageContainer.addSubview(txtMessage)
        
        txtMessage.fillSuperView(padding: .init(top: 5, left: 12, bottom: 5, right: 12))
    }
}
