//
//  PhotoTransitionController.swift
//  letsMeet
//
//  Created by aisenur on 2.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class PhotoTransitionController: UIPageViewController {
    
    var userProfileVM: UserProfileViewModel! {
        didSet {
            controllers = userProfileVM.imageNames.map({ (imageURL) -> UIViewController in
                let photoController = PhotoController(imageURL: imageURL)
                return photoController
            })
            
              setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
            addBarView()
        }
    }
    
    fileprivate let unselectedColor = UIColor(white: 0, alpha: 0.4)
    fileprivate let barStackView = UIStackView(arrangedSubviews: [])
    
    fileprivate func addBarView() {
        userProfileVM.imageNames.forEach { (_) in
            let barView = UIView()
            barView.layer.cornerRadius = 2
            barView.backgroundColor = unselectedColor
            barStackView.addArrangedSubview(barView)
        }
        
        barStackView.arrangedSubviews.first?.backgroundColor = .white
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
        
        view.addSubview(barStackView)
        _ = barStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
    }
    
    fileprivate var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        dataSource = self
        delegate = self
        
        if isUserVM {
            cancelPhotoTransition()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGesturePhoto)))
    }
    
    @objc fileprivate func tapGesturePhoto(gesture: UITapGestureRecognizer) {
        let currentController = viewControllers!.first!
       
        if let index = controllers.firstIndex(of: currentController) {
            
            barStackView.arrangedSubviews.forEach({ $0.backgroundColor = unselectedColor })
            
            if gesture.location(in: self.view).x > (view.frame.width / 2) {
                
                let nextIndex = min(controllers.count-1, index+1)
                let nextController = controllers[nextIndex]
                setViewControllers([nextController], direction: .forward, animated: true, completion: nil)
                barStackView.arrangedSubviews[nextIndex].backgroundColor = .white
                
            } else {
                
                let previousIndex = max(0, index-1)
                let previousController = controllers[previousIndex]
                setViewControllers([previousController], direction: .forward, animated: true, completion: nil)
                barStackView.arrangedSubviews[previousIndex].backgroundColor = .white
            }
        }
    }
    
    fileprivate func cancelPhotoTransition() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    fileprivate let isUserVM: Bool
    
    init(isUserVM: Bool = false) {
        self.isUserVM = isUserVM
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhotoTransitionController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == 0 { return nil }
        return controllers[index-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let index = self.controllers.firstIndex(where: { $0 == viewController }) ?? 0
        if index == controllers.count-1 { return nil }
        return controllers[index+1]
    }
}

extension PhotoTransitionController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let currentPhotoController = viewControllers?.first
        
        if let index = controllers.firstIndex(where: { $0 == currentPhotoController }) {
            barStackView.arrangedSubviews.forEach({ $0.backgroundColor = unselectedColor })
            barStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
}


class PhotoController: UIViewController {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "shakira1"))
    
    init(imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.fillSuperView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
