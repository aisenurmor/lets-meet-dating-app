//
//  MatchingHorizontalController.swift
//  letsMeet
//
//  Created by aisenur on 14.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

//Eşleşilen profilleri listelemek için
class MatchingHorizontalController: ListController<MatchingCell, Matching>, UICollectionViewDelegateFlowLayout {
    
    var rootMatchingMessagesController: MatchingMessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.showsHorizontalScrollIndicator = false
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        getMatching()
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = data[indexPath.item]
        rootMatchingMessagesController?.matchingCardPressed(match: match)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 110, height: view.frame.height)
    }
}
