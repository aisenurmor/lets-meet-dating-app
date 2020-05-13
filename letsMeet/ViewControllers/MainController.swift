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
        navigationController?.navigationBar.isHidden = true
        
        topView.chatButton.addTarget(self, action: #selector(chatButtonPressed), for: .touchUpInside)
        topView.profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        bottomView.btnReload.addTarget(self, action: #selector(reloadButtonPressed), for: .touchUpInside)
        bottomView.btnLike.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        bottomView.btnClose.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        
        editLayout()
        getUserData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            let registerController = RegisterController()
            registerController.delegate = self
            let navController = UINavigationController(rootViewController: registerController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    fileprivate var currentUser: User?
    fileprivate func getUserData() {
        profilesView.subviews.forEach({ $0.removeFromSuperview() })
        
        Firestore.firestore().getUserInformations { (user, err) in
            if let err = err {
                print(err)
                return
            }
            self.currentUser = user
            self.getTransitions()
        }
    }
    
    var currentVisibleProfile: PersonCardView?
    //MARK: - Reload Button Pressed
    @objc fileprivate func reloadButtonPressed() {
        profilesView.subviews.forEach({ $0.removeFromSuperview() })
        getUserData()
    }
    
    var users = [String: User]()
    //MARK: - Like Button Pressed
    @objc func likeButtonPressed() {
        saveTransitionToFirestore(likeStatus: 1)
        personCardTransitionAnimation(translation: 800, angle: 20)
    }
    
    //MARK: - Close Button Pressed
    @objc func closeButtonPressed() {
        saveTransitionToFirestore(likeStatus: -1)
        personCardTransitionAnimation(translation: -800, angle: -20)
    }
    
    fileprivate func saveTransitionToFirestore(likeStatus: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let personId = currentVisibleProfile?.userViewModel.userId else { return}
        
        let data = [personId: likeStatus]
        
        Firestore.firestore().collection("Transitions").document(userId).getDocument { (snapshot, err) in
            if err != nil {
                return
            }
            
            if snapshot?.exists == true {
            Firestore.firestore().collection("Transitions").document(userId).updateData(data) { (err) in
                    
                    if err != nil {
                        return
                    }
                    if likeStatus == 1 {
                        self.matchingControl(personId: personId)
                    }
                }
            } else {
                Firestore.firestore().collection("Transitions").document(userId).setData(data) { (err) in
                    if err != nil {
                        return
                    }
                    if likeStatus == 1 {
                        self.matchingControl(personId: personId)
                    }
                    
                }
            }
        }
    }
    
    
    fileprivate func matchingControl(personId: String) {
        Firestore.firestore().collection("Transitions").document(personId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error, \(err)")
                return
            }

            guard let data = snapshot?.data() else { return }
            guard let userId = Auth.auth().currentUser?.uid else { return }
            
            let isMatched = data[userId] as? Int == 1
           
            if isMatched {
                self.getMatchingView(personId: personId)
                
                //For logged in user
                guard let matchedUser = self.users[personId] else { return }
                let dataToAdd: [String : Any] = [
                    "nameSurname": matchedUser.userName ?? "",
                    "imageUrl": matchedUser.imageURL ?? "",
                    "uuid": matchedUser.userId,
                    "timestamp": Timestamp(date: Date())]
                Firestore.firestore().collection("Matches_Messages").document(userId).collection("Matches").document(personId).setData(dataToAdd) { (err) in
                    if let err = err {
                        print("Error, \(err)")
                    }
                }
                
                //For matched user
                guard let currenctUser = self.currentUser else { return }
                let dataToAddForPerson: [String: Any] = [
                    "nameSurname": currenctUser.userName ?? "",
                    "imageUrl": currenctUser.imageURL ?? "",
                    "uuid": currenctUser.userId,
                    "timestamp": Timestamp(date: Date())]
                Firestore.firestore().collection("Matches_Messages").document(personId).collection("Matches").document(userId).setData(dataToAddForPerson) { (err) in
                    if let err = err {
                        print("Error, \(err)")
                    }
                }
            }
        }
    }
    
    fileprivate func getMatchingView(personId: String) {
        let matchingView = MatchingView()
        matchingView.personId = personId
        matchingView.currentUser = currentUser
        view.addSubview(matchingView)
        matchingView.fillSuperView()
    }
    
    fileprivate func personCardTransitionAnimation(translation: CGFloat, angle: CGFloat) {
        
        let basicAnimation = CABasicAnimation(keyPath: "position.x")
        basicAnimation.toValue = translation
        basicAnimation.duration = 1
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        let spinningAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        spinningAnimation.toValue = CGFloat.pi * angle / 180
        spinningAnimation.duration = 1
        
        let pView = currentVisibleProfile
        currentVisibleProfile = pView?.nextPersonCard
        
        CATransaction.setCompletionBlock({
            pView?.removeFromSuperview()
        })
        
        pView?.layer.add(basicAnimation, forKey: "animation")
        pView?.layer.add(spinningAnimation, forKey: "spinning")
        
        CATransaction.commit()
    }
    
    //MARK: - Get User Transitions from FireStore
    var transitionData = [String: Int]()
    fileprivate func getTransitions() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("Transitions").document(userId).getDocument { (snapshot, err) in
            if let err = err {
                print("Error, \(err)")
                return
            }
            guard let data = snapshot?.data() as? [String: Int] else {
                self.transitionData.removeAll()
                self.getUsersFromFS()
                return
            }
            self.transitionData = data
            self.getUsersFromFS()
        }
    }
    
    //MARK: - Get User Data From FireStore
    var lastFetchedUser: User?
    fileprivate func getUsersFromFS() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Profiles loading..."
        hud.show(in: view)
        
        let minAge = currentUser?.minAgeCriteria ?? ProfileController.defaultMinAge
        let maxAge = currentUser?.maxAgeCriteria ?? ProfileController.defaultMaxAge
        
        let query = Firestore.firestore().collection("Users")
            .whereField("age", isGreaterThanOrEqualTo: minAge)
            .whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 7)
        
        currentVisibleProfile = nil
        
        query.getDocuments { (snapshot, err) in
            hud.dismiss()
            
            if let err = err {
                print("Error, \(err)")
                return
            }
            
            var previousPersonCard: PersonCardView?
            snapshot?.documents.forEach({ (dSnapshot) in
                let userData = dSnapshot.data()
                let user = User(informations: userData)
                
                self.users[user.userId] = user
                
                let isCurrentUser = user.userId == Auth.auth().currentUser?.uid
                //let isTransitionData = self.transitionData[user.userId] != nil
                let isTransitionData=false
                
                if !isCurrentUser && !isTransitionData {
                    let pView = self.createProfileFromUser(user: user)
                    
                    //nil ise ilk profil gelmiş demektir
                    if self.currentVisibleProfile == nil {
                        self.currentVisibleProfile = pView
                    }
                    previousPersonCard?.nextPersonCard = pView
                    previousPersonCard = pView
                }
            })
        }
    }
    
    fileprivate func createProfileFromUser(user: User) -> PersonCardView {
        let personCard = PersonCardView()
        personCard.delegate = self
        personCard.userViewModel = user.createUserProfileViewModel()
        
        profilesView.addSubview(personCard)
        profilesView.sendSubviewToBack(personCard) //fifo
        personCard.fillSuperView()
        
        return personCard
    }
    
    //MARK: - Profile Button Pressed
    @objc func profileButtonPressed() {
        let profileController = ProfileController()
        profileController.delegate = self
        let navController = UINavigationController(rootViewController: profileController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    //MARK: - Chat Button Pressed
    @objc fileprivate func chatButtonPressed() {
        let viewController = MatchingMessagesController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func editLayout() {
        view.backgroundColor = .white
        
        let mainStackView = UIStackView(arrangedSubviews: [topView, profilesView, bottomView])
        mainStackView.axis = .vertical
        
        view.addSubview(mainStackView)
        mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        
        mainStackView.bringSubviewToFront(profilesView) //profil card en önde
    }
}


extension MainController: ProfileControllerDelegate {
    func criteriasSaved() {
        getUserData()
    }
}

//Kullanıcı oturum açtığı an getUserData fonk nu tetikleniyor
extension MainController: LoginControllerDelegate {
    func doneLogin() {
        getUserData()
    }
}

extension MainController: PersonCardDelegate {
    
    //Person card kaydırılıp kaldırıldığında bu fonksiyon da tetiklenir ve currentVisibleProfile güncellenir.
    func removePersonFromList(person: PersonCardView) {
        self.currentVisibleProfile?.removeFromSuperview()
        self.currentVisibleProfile = self.currentVisibleProfile?.nextPersonCard
    }
    
    func detailPressed(userProfileVM userVM: UserProfileViewModel) {
        let userDetailController = UserDetailController()
        userDetailController.userVM = userVM
        userDetailController.modalPresentationStyle = .fullScreen
        present(userDetailController, animated: true)
    }
}
