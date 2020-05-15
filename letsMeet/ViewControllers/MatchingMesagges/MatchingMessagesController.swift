//
//  MatchingMessagesController.swift
//  letsMeet
//
//  Created by aisenur on 10.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

struct LastMessage {
    let message: String
    let userId: String
    let userNameSurname: String
    let imageURL: String
    let timestamp: Timestamp
    
    init(data: [String: Any]) {
        message = data["message"] as? String ?? ""
        userId = data["userId"] as? String ?? ""
        userNameSurname = data["userNameSurname"] as? String ?? ""
        imageURL = data["imageURL"] as? String ?? ""
        timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

class LastMessagesCell: ListCell<LastMessage> {
    
    let profileImage = UIImageView(image: #imageLiteral(resourceName: "person2"), contentMode: .scaleAspectFill)
    let lblUserName = UILabel(text: "Aişe", font: .boldSystemFont(ofSize: 17), textColor: .darkGray)
    let lblLastMessage = UILabel(text: "Selam, ashdjhajdhjahdjs hajdhajsdjahjd lakjsadhasşsşa şaldşsakdfjekjnsdvndfv ksjfkk. şaldşsakdfjekjnsdvndfv ksjfkk şaldşsakdfjekjnsdvndfv ksjfkk şaldşsakdfjekjnsdvndfv ksjfkk", font: .systemFont(ofSize: 14), textColor: .lightGray, numberOfLines: 2)
    
    override var data: LastMessage! {
        didSet {
            lblUserName.text = data.userNameSurname
            lblLastMessage.text = data.message
            profileImage.sd_setImage(with: URL(string: data.imageURL))
        }
    }
    
    override func creatViews() {
        super.creatViews()
        
        let imageSize: CGFloat = 80
        profileImage.layer.cornerRadius = imageSize/2
        
        createHorizontalStackView(profileImage.resize(.init(width: imageSize, height: imageSize)), createStackView(lblUserName, lblLastMessage, spacing: 5), spacing: 20, alignment: .center).padLeft(16).padRight(16)
        
        addSeperate()
    }
}

class MatchingMessagesController: ListHeaderController<LastMessagesCell, LastMessage, MatchingHeader> {
    
    fileprivate let navBar = MatchingNavBar()
    fileprivate let navBarHeight: CGFloat = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLastMessages()
        
        editView()
    }
    
    fileprivate func editView() {
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = navBarHeight
        collectionView.verticalScrollIndicatorInsets.top = navBarHeight
        
        let statusBar = UIView(backgroundColor: .white)
        view.addSubview(statusBar)
        statusBar.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        
        view.addSubview(navBar)
        navBar.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
    }
    
    var lastMessages = [String: LastMessage]()
    fileprivate func getLastMessages() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Matches_Messages").document(currentUser).collection("Last_Messages").addSnapshotListener { (snapshot, err) in
            if let err = err {
                print("Error, \(err)")
                return
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added || change.type == .modified {
                    let addedlastMessage = change.document.data()
                    let lastMessage = LastMessage(data: addedlastMessage)
                    self.lastMessages[lastMessage.userId] = lastMessage
                }
                
                //mesaj silindiyse
                if change.type == .removed {
                    let message = change.document.data()
                    let messageToBeDeleted = LastMessage(data: message)
                    self.lastMessages.removeValue(forKey: messageToBeDeleted.userId)
                }
            })
            self.resetData()
        }
    }
    
    fileprivate func resetData() {
        let lastMessagesArray = Array(lastMessages.values)
        data = lastMessagesArray.sorted(by: { (firstMessage, secondMessage) -> Bool in
            return firstMessage.timestamp.compare(secondMessage.timestamp) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    //MatchingHorizontalController içerisine referans olarak MatchingMessagesController'ı attık
    override func setHeader(_ header: MatchingHeader) {
        header.matchesHorizontalVC.rootMatchingMessagesController = self
    }
    
    //MatchingHorizontalController'dan navigationController'a ulaşamadığımız için
    func matchingCardPressed(match: Matching) {
        let messageController = MessageController(matching: match)
        navigationController?.pushViewController(messageController, animated: true)
    }
}

extension MatchingMessagesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 4, bottom: 16, right: 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastMessage = self.data[indexPath.row]
        
        let matchingData = ["nameSurname": lastMessage.userNameSurname, "imageUrl": lastMessage.imageURL, "uuid": lastMessage.userId]
        let matching = Matching(data: matchingData)
        let messageController = MessageController(matching: matching)
        
        navigationController?.pushViewController(messageController, animated: true)
    }
}
