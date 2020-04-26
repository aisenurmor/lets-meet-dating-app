//
//  ViewController.swift
//  letsMeet
//
//  Created by aisenur on 14.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class MainController: UIViewController {
    
    let topView = NavbarStackView()
    let profilesView = UIView()
    let bottomView = TabbarStackView()
    
    var userProfileViewModel = [UserProfileViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        bottomView.btnReload.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        
        editLayout()
        setProfileCard()
        
        getUserDataFromFS()
    }
    
    @objc fileprivate func reloadButtonPressed() {
        getUserDataFromFS()
    }
    
    //MARK: - Get User Data From FireStore
    var lastFetchedUser: User?
    fileprivate func getUserDataFromFS() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profiles loading..."
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("Users")
            .order(by: "uuid")
            .start(after: [lastFetchedUser?.userId ?? ""])
            .limit(to: 2)
        
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            
            if let err = err {
                print("Error, \(err)")
                return
            }
            
            snapshot?.documents.forEach({ (dSnapshot) in
                let userData = dSnapshot.data()
                let user = User(informations: userData)
                
                self.userProfileViewModel.append(user.createUserProfileViewModel())
                self.lastFetchedUser = user
                
                self.createProfileFromUser(user: user)
            })
        }
    }
    
    fileprivate func createProfileFromUser(user: User) {
        let personCard = PersonCardView()
        
        personCard.userViewModel = user.createUserProfileViewModel()
        
        profilesView.addSubview(personCard)
        personCard.fillSuperView()
    }
    
    @objc func profileButtonPressed() {
        let profileController = ProfileController()
        let navController = UINavigationController(rootViewController: profileController)
        present(navController, animated: true, completion: nil)
    }
    
    func editLayout() {
        view.backgroundColor = .white
        
        let mainStackView = UIStackView(arrangedSubviews: [topView, profilesView, bottomView])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        _ = mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        mainStackView.bringSubviewToFront(profilesView) //profil card en önde
    }
    
    func setProfileCard() {
        userProfileViewModel.forEach { (userVM) in
            let personCard = PersonCardView()
            
            personCard.userViewModel = userVM
            
            profilesView.addSubview(personCard)
            personCard.fillSuperView()
        }
        
    }
    
}

