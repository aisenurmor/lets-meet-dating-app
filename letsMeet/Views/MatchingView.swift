//
//  MatchingView.swift
//  letsMeet
//
//  Created by aisenur on 7.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

class MatchingView: UIView {
    
    let imageSize = UIScreen.main.bounds.width*0.32
    let screenSize = UIScreen.main.bounds
    
    var currentUser: User!
    
    var personId: String! {
        didSet {
            let query = Firestore.firestore().collection("Users")
            query.document(personId).getDocument { (snapshot, err) in
                if let err = err {
                    print("Error, \(err)")
                    return
                }
                guard let personData = snapshot?.data() else { return }
                let user = User(informations: personData)
                
                guard let url = URL(string: user.imageURL ?? "") else { return }
                self.matchedUserImage.sd_setImage(with: url)
                
                guard let currentUserImageURL = URL(string: self.currentUser.imageURL ?? "") else { return }
                self.currentUserImage.sd_setImage(with: currentUserImageURL) { (_, _, _, _) in
                    self.createAnimations()
                }
                self.lblSubTitle.text = "You and \(user.userName ?? "unknown") like each other"
            }
        }
    }
    
    fileprivate let btnSendMessage: UIButton = {
        let btn = SendMessageButton()
        btn.setTitle("SEND A MESSAGE", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        
        return btn
    }()
    
    fileprivate let btnKeepSwiping: UIButton = {
        let btn = KeepSwipingButton()
        btn.setTitle("KEEP SWIPING", for: .normal)
        btn.setTitleColor(.white, for: .normal)

        return btn
    }()
    
    fileprivate let lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "You matched!"
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
        lbl.textColor = .white
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    fileprivate let lblSubTitle: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lbl.textColor = .lightGray
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    fileprivate let currentUserImage: UIImageView = {
       let img = UIImageView(image: #imageLiteral(resourceName: "person3"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        
       return img
    }()
    
    fileprivate let matchedUserImage: UIImageView = {
       let img = UIImageView(image: #imageLiteral(resourceName: "person2"))
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        
       return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBlurEffect()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureMatching)))
        editLayout()
    }
    
    fileprivate func createAnimations() {
        views.forEach({ $0.alpha = 1 })
        
        let angle = 25 * CGFloat.pi / 180
        currentUserImage.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 220, y: 0))
        matchedUserImage.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -220, y: 0))
        
        btnSendMessage.transform = CGAffineTransform(translationX: -450, y: 0)
        btnKeepSwiping.transform = CGAffineTransform(translationX: 450, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.currentUserImage.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImage.transform = CGAffineTransform(rotationAngle: angle)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImage.transform = .identity
                self.matchedUserImage.transform = .identity
                
                self.btnSendMessage.transform = .identity
                self.btnKeepSwiping.transform = .identity
            }
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.9, delay: 0.8, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            self.btnSendMessage.transform = .identity
            self.btnKeepSwiping.transform = .identity
        })
        
        
        UIView.animate(withDuration: 0.85, animations: {
            self.currentUserImage.transform = .identity
            self.matchedUserImage.transform = .identity
        }) { (_) in
            
        }
    }
    
    
    lazy var views = [
    currentUserImage,
    matchedUserImage,
    lblTitle,
    lblSubTitle,
    btnSendMessage,
    btnKeepSwiping
    ]
    
    fileprivate func editLayout() {
        views.forEach { (v) in
            addSubview(v)
            v.alpha = 0
        }
        
        addSubview(currentUserImage)
        addSubview(matchedUserImage)
        addSubview(lblTitle)
        addSubview(lblSubTitle)
        addSubview(btnSendMessage)
        addSubview(btnKeepSwiping)
        
        _ = currentUserImage.anchor(top: nil, bottom: nil, leading: nil, trailing: self.centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 18), size: .init(width: imageSize, height: imageSize))
        currentUserImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        currentUserImage.layer.cornerRadius = self.imageSize/2
        
        _ = matchedUserImage.anchor(top: nil, bottom: nil, leading: self.centerXAnchor, trailing: nil, padding: .init(top: 0, left: 18, bottom: 0, right: 0), size: .init(width: imageSize, height: imageSize))
        matchedUserImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        matchedUserImage.layer.cornerRadius = self.imageSize/2
        
        _ = lblTitle.anchor(top: nil, bottom: self.lblSubTitle.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 0, left: 45, bottom: 10, right: 45))
        lblTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        _ = lblSubTitle.anchor(top: nil, bottom: self.currentUserImage.topAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 10, left: 45, bottom: screenSize.height*0.05, right: 45))
        lblSubTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        _ = btnSendMessage.anchor(top: self.currentUserImage.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: screenSize.height*0.05, left: 45, bottom: 0, right: 45), size: .init(width: 0, height: screenSize.height*0.05))
        btnSendMessage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        _ = btnKeepSwiping.anchor(top: self.btnSendMessage.bottomAnchor, bottom: nil, leading: self.leadingAnchor, trailing: self.trailingAnchor, padding: .init(top: 15, left: 45, bottom: 0, right: 45), size: .init(width: 0, height: screenSize.height*0.05))
        btnKeepSwiping.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    //MARK: - Visual Effect Operations
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    fileprivate func addBlurEffect() {
        addSubview(visualEffectView)
        visualEffectView.fillSuperView()
        
        visualEffectView.alpha = 0
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) { (_) in
            
        }
    }
    
    @objc fileprivate func tapGestureMatching() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
