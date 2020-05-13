//
//  MessageController.swift
//  letsMeet
//
//  Created by aisenur on 11.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

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

class MessageController: ListController<MessageCell, Message>, UITextViewDelegate {
    
    fileprivate lazy var navBar = MessageNavBar(matching: matching)
    fileprivate let navBarHeight: CGFloat = 110
    fileprivate let matching: Matching
    
    init(matching: Matching) {
        self.matching = matching
        super.init()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    class SendMessageView: UIView {
        override var intrinsicContentSize: CGSize {
            return .zero
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .white
            addShadow(opacity: 0.2, radius: 15, offset: .init(width: 0, height: -5), color: .init(white: 0, alpha: 0.2))
            autoresizingMask = .flexibleHeight //boyutu içeriğe göre ayarla
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let txtMessage = UITextView()
    let lblPlaceholder = UILabel(text: "Your message...", font: .systemFont(ofSize: 15), textColor: .lightGray)
    
    lazy var messageView: SendMessageView = {
        
        let messageView = SendMessageView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 60))
        
        let sendButton = UIButton(title: "Send", titleColor: #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1), titleFont: .boldSystemFont(ofSize: 16))
        sendButton.resize(.init(width: 60, height: 60))
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        
        txtMessage.text = ""
        txtMessage.font = .systemFont(ofSize: 17)
        txtMessage.isScrollEnabled = false
        messageView.addSubview(txtMessage)
        txtMessage.fillSuperView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(txtMessageChanged), name: UITextView.textDidChangeNotification, object: nil)
        
        messageView.createHorizontalStackView(txtMessage, sendButton.resize(.init(width: 60, height: 60)), alignment: .center).withMargin(.init(top: 0, left: 16, bottom: 0, right: 16))
        
        messageView.addSubview(lblPlaceholder)
        lblPlaceholder.anchor(top: nil, bottom: nil, leading: messageView.leadingAnchor, trailing: sendButton.leadingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        lblPlaceholder.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        
        return messageView
    }()
    
    //klavyenin geleceği alana eklemek için
    override var inputAccessoryView: UIView? {
        get {
            return messageView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtMessage.delegate = self
        
        //collectionView scrolu ile klavyenin interaktif bir şekilde çalışması için
        collectionView.keyboardDismissMode = .interactive
        
        navBar.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        getMessages()
        
        editLayout()
    }
    
    fileprivate func getMessages() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let query = Firestore.firestore().collection("Matches_Messages").document(currentUserId).collection(matching.userId).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, err) in
            if let err = err {
                            print("Error, \(err)")
                            return
                        }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let newMessage = change.document.data()
                    self.data.append(.init(data: newMessage))
                    
                    self.collectionView.scrollToItem(at: [0, self.data.count-1], at: .bottom, animated: true)
                }
                self.collectionView.reloadData()
            })
        }
    }
    
    fileprivate func editLayout() {
        view.addSubview(navBar)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        collectionView.contentInset.top = navBarHeight
        
        let statusBar = UIView(backgroundColor: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        //collectionView scrollunun navbarın altından başlamasını engellemek için
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func txtMessageChanged() {
        lblPlaceholder.isHidden = txtMessage.text.count != 0
    }
    
    @objc fileprivate func sendButtonPressed() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let addToData: [String: Any] = [
            "message": txtMessage.text ?? "",
            "senderId": currentUserId,
            "receiverId": matching.userId,
            "timestamp": Timestamp(date: Date())
        ]
        
        let query = Firestore.firestore().collection("Matches_Messages").document(currentUserId).collection(matching.userId)
        query.addDocument(data: addToData) { (err) in
            if let err = err {
                print("Error, \(err)")
                return
            }
            self.txtMessage.text = nil
            self.lblPlaceholder.isHidden = false
        }
        
        let queryOfReceiver = Firestore.firestore().collection("Matches_Messages").document(matching.userId).collection(currentUserId)
        
        queryOfReceiver.addDocument(data: addToData) { (err) in
            if let err = err {
                print("Error, \(err)")
                return
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.collectionView.scrollToItem(at: [0, data.count-1], at: .bottom, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MessageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let estimatedCell = MessageCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
        
        estimatedCell.data = self.data[indexPath.item]
        estimatedCell.layoutIfNeeded() //gerekliyse tekrar boyutlandır
        
        let estimatedSize = estimatedCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 8, bottom: 16, right: 8)
    }
}

