//
//  MatchingMessagesController.swift
//  letsMeet
//
//  Created by aisenur on 10.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

class MatchingCell: ListCell<Matching> {
    
    let imgProfile = UIImageView(image: UIImage(named: "person3"), contentMode: .scaleAspectFill)
    let lblUserName = UILabel(text: "Aise", font: .systemFont(ofSize: 15), textColor: .darkGray, textAlignment: .center, numberOfLines: 2)
    
    override var data: Matching! {
        didSet {
            lblUserName.text = data.username
            imgProfile.sd_setImage(with: URL(string: data.profileImageURL))
        }
    }
    
    override func creatViews() {
        super.creatViews()
        
        imgProfile.clipsToBounds = true
        imgProfile.resize(.init(width: 80, height: 80))
        imgProfile.layer.cornerRadius = 40
        imgProfile.addBorder(width: 3, color: .darkGray)
        
        createStackView(createStackView(imgProfile, alignment: .center), lblUserName)
    }
}

class MatchingMessagesController: ListController<MatchingCell, Matching> {
    
    let navBar = MatchingNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMatching()
        
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 110
        
        view.addSubview(navBar)
        
        navBar.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        navBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 110))
    }
    
    @objc fileprivate func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 4, bottom: 16, right: 4)
    }
    
    fileprivate func getMatching() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Matches_Messages").document(currentUser).collection("Matches").getDocuments { (snapshot, err) in
            if let err = err {
                print("Error, \(err)")
                return
            }
            
            var matches = [Matching]()
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let data = documentSnapshot.data()
                matches.append(.init(data: data))
            })
            
            self.data = matches
            self.collectionView.reloadData()
        }
    }
    
    
}

extension MatchingMessagesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: 130)
    }
}

extension MatchingMessagesController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = data[indexPath.item]
        print(match.username, "**************************")
        let messageController = MessageController(matching: match)
        navigationController?.pushViewController(messageController, animated: true)
    }
}
