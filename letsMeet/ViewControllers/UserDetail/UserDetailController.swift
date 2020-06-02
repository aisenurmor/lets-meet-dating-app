//
//  UserDetailController.swift
//  letsMeet
//
//  Created by aisenur on 30.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailController: UIViewController {
    
    var userVM: UserProfileViewModel! {
        didSet {
            lblInfo.attributedText = userVM.attrString
            photoTransitionController.userProfileVM = userVM
        }
    }

    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        
        return sv
    }()
    
    let photoTransitionController = PhotoTransitionController()
    
    let lblInfo: UILabel = {
       let lbl = UILabel()
        lbl.text = ""
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    let btnCloseDetail: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "down-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.4392156863, green: 0.631372549, blue: 1, alpha: 1)
        btn.addTarget(self, action: #selector(closeTapGesture), for: .touchUpInside)
        
        return btn
    }()
    
    fileprivate func editLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.fillSuperView()
        
        let photoTransitionView = photoTransitionController.view!
        scrollView.addSubview(photoTransitionView)
        photoTransitionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(lblInfo)
        _ = lblInfo.anchor(top: photoTransitionView.bottomAnchor, bottom: nil, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        scrollView.addSubview(btnCloseDetail)
        _ = btnCloseDetail.anchor(top: photoTransitionView.bottomAnchor, bottom: nil, leading: nil, trailing: view.trailingAnchor, padding: .init(top: -28, left: 0, bottom: 0, right: 10), size: .init(width: 55, height: 55))
    }
    
    fileprivate func createButton(image: UIImage, tintColor: UIColor, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = tintColor
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
        return btn
    }
    
    lazy var btnDislike = createButton(image: #imageLiteral(resourceName: "close"), tintColor: #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3960784314, alpha: 1), selector: #selector(btnDislikePressed))
    lazy var btnSuperLike = createButton(image: #imageLiteral(resourceName: "star"), tintColor: #colorLiteral(red: 0.9960784314, green: 0.8274509804, blue: 0.1882352941, alpha: 1), selector: #selector(btnSuperlikePressed))
    lazy var btnLike = createButton(image: #imageLiteral(resourceName: "heart"), tintColor: #colorLiteral(red: 0.9882352941, green: 0.3607843137, blue: 0.3960784314, alpha: 1), selector: #selector(btnLikePressed))
    
    @objc fileprivate func btnDislikePressed() {
        
    }
    
    @objc fileprivate func btnSuperlikePressed() {
        
    }
    
    @objc fileprivate func btnLikePressed() {
        
    }
    
    fileprivate func bottomButtonsLocate() {
        let sv = UIStackView(arrangedSubviews: [btnLike, btnSuperLike, btnDislike])
        sv.distribution = .fillEqually
        
        sv.spacing = 10
        
        view.addSubview(sv)
        
        _ = sv.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 10, right: 0), size: .init(width: view.bounds.width*0.6, height: 40))
        sv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate let additionHeight: CGFloat = 70
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let width = view.frame.width
        let photoTransitionView = photoTransitionController.view!
        photoTransitionView.frame = CGRect(x: 0, y: 0, width: width, height: width+additionHeight)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editLayout()
        createBlurEffect()
        bottomButtonsLocate()
    }
    
    fileprivate func createBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        
        view.addSubview(effectView)
        _ = effectView.anchor(top: view.topAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
    
    @objc fileprivate func closeTapGesture() {
        self.dismiss(animated: true)
    }
}

extension UserDetailController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yValue = scrollView.contentOffset.y
        var width = view.frame.width - 2*yValue
        width = max(view.frame.width, width)
        
        let imgProfile = photoTransitionController.view!
        imgProfile.frame = CGRect(x: min(0, yValue), y: min(0, yValue), width: width, height: width + additionHeight)
    }
}
