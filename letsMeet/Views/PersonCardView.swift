//
//  PersonCardView.swift
//  letsMeet
//
//  Created by aisenur on 15.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import SDWebImage

class PersonCardView: UIView {
    
    var nextPersonCard: PersonCardView?
    var delegate : PersonCardDelegate?
    var userViewModel: UserProfileViewModel! {
        didSet {
            photoTransitionController.userProfileVM = userViewModel
            
            userInformation.attributedText = userViewModel.attrString
            userInformation.textAlignment = userViewModel.informationAlignment
            
            
            (0..<userViewModel.imageNames.count).forEach { (_) in
                let bView = UIView()
                bView.backgroundColor = unselectedColor
                imageBarStackView.addArrangedSubview(bView)
            }
            imageBarStackView.arrangedSubviews.first?.backgroundColor = .white
            setImageIndexObserver()
        }
    }
    
    fileprivate func setImageIndexObserver() {
        userViewModel.imageIndexObserver = { (imageURL, index) in
            
            self.imageBarStackView.arrangedSubviews.forEach { (view) in
                view.backgroundColor = self.unselectedColor
            }
            self.imageBarStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    fileprivate let photoTransitionController = PhotoTransitionController(isUserVM: true)
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let imageBarStackView = UIStackView()
    let userInformation = UILabel()
    
    let detailButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "info")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(detailBtnClicked), for: .touchUpInside)
        
        return btn
    }()
    
    fileprivate let unselectedColor = UIColor(white: 0, alpha: 0.4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        editLayout()
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(catchCardPan))
        addGestureRecognizer(panG)
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(catchCardTap))
        addGestureRecognizer(tapG)
    }
    
    @objc fileprivate func detailBtnClicked() {
        delegate?.detailPressed(userProfileVM: userViewModel)
    }
    
    fileprivate func editLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let photoTransitionView = photoTransitionController.view!
        addSubview(photoTransitionView)
        photoTransitionView.fillSuperView()
        
        createGradientLayer()
        
        addSubview(userInformation)
        userInformation.textColor = .white
        userInformation.numberOfLines = 0
        
        addSubview(detailButton)
    }
    
    //MARK: - PanGesture Operations
    @objc fileprivate func catchCardPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .changed:
            panCatchChange(panGesture)
        case .ended:
            panAnimationFinish(panGesture)
        default:
            break
        }
    }
    
    fileprivate func panAnimationFinish(_ panGesture: UIPanGestureRecognizer) {
        let limitValue: CGFloat = 120
        
        let translationDirection: CGFloat = panGesture.translation(in: nil).x > 0 ? 1 : -1
        let removeCard: Bool = abs(panGesture.translation(in: nil).x) > limitValue
        
        guard let mainController = self.delegate as? MainController else { return }
        
        if removeCard {
            if translationDirection == 1 {
                mainController.likeButtonPressed()
            } else {
                mainController.closeButtonPressed()
            }
        } else {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.transform = .identity //(0,0) konumuna geri gönderir
            })
        }
    }
    
    fileprivate func panCatchChange(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: nil)
        
        let degree: CGFloat = translation.x / 15
        let radianAngle = (degree * .pi) / 180
        
        let rotateTransform = CGAffineTransform(rotationAngle: radianAngle)
        self.transform = rotateTransform.translatedBy(x: translation.x, y: translation.y)
    }
    
    //MARK: - Gradient Layer Operations
    fileprivate func createGradientLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.4, 1.2]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        gradientLayer.frame = self.frame
        userInformation.frame = self.frame(forAlignmentRect: CGRect(x: 18, y: frame.height-100, width: frame.width-36, height: 100))

        detailButton.frame = self.frame(forAlignmentRect: CGRect(x: frame.width-55, y: frame.height-70, width: 40, height: 40))
    }
    
    //MARK: - Tap Recognizer Operations
    var imageIndex = 0
    @objc fileprivate func catchCardTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: nil)
        
        let nextImage = location.x > self.frame.width / 2
        
        if nextImage {
            userViewModel.nextImage()
        } else {
            userViewModel.previousImage()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init oluşturulmadı.")
    }
}

protocol PersonCardDelegate {
    func removePersonFromList(person: PersonCardView)
    func detailPressed(userProfileVM: UserProfileViewModel)
}
