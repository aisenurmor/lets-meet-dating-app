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
    
    var userViewModel: UserProfileViewModel! {
        didSet {
            let imageName = userViewModel.imageNames.first ?? ""
            
            if let url = URL(string: imageName) {
                imgProfile.sd_setImage(with: url)
            }
            
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
            
            if let url = URL(string: imageURL) {
                self.imgProfile.sd_setImage(with: url)
            }
        }
    }
    
    fileprivate let imgProfile = UIImageView(image: #imageLiteral(resourceName: "person"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let imageBarStackView = UIStackView()
    let userInformation = UILabel()
    
    fileprivate let unselectedColor = UIColor(white: 0, alpha: 0.4)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        editLayout()
        
        let panG = UIPanGestureRecognizer(target: self, action: #selector(catchCardPan))
        addGestureRecognizer(panG)
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(catchCardTap))
        addGestureRecognizer(tapG)
    }
    
    fileprivate func editLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imgProfile.contentMode = .scaleAspectFill
        
        addSubview(imgProfile)
        fillSuperView()
        
        createBarStackView()
        createGradientLayer()
        
        addSubview(userInformation)
        
        _ = userInformation.anchor(top: nil, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 18, bottom: 18, right: 18))
        userInformation.textColor = .white
        userInformation.numberOfLines = 0
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
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            if removeCard {
                let removeCardTranslation = self.transform.translatedBy(x: 1000*translationDirection, y: 0)
                self.transform = removeCardTranslation
            } else {
                self.transform = .identity //başladığı yere gönderir
            }
            
        }) { (_) in
            self.transform = .identity
            
            if removeCard {
                self.removeFromSuperview()
            }
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
        imageBarStackView.frame = self.frame(forAlignmentRect: CGRect(x: 8, y: 10, width: frame.width, height: 10))
    }
    
    //MARK: - More Photos Operations
    fileprivate func createBarStackView() {
        addSubview(imageBarStackView)
        
        _ = imageBarStackView.anchor(top: topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        imageBarStackView.spacing = 4
        imageBarStackView.distribution = .fillEqually
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
