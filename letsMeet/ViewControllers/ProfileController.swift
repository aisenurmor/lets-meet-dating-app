//
//  SettingController.swift
//  letsMeet
//
//  Created by aisenur on 24.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    fileprivate func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.setTitle("Choose Photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        
        return button
    }
    
    lazy var firstImageButton = createButton(selector: #selector(chooseImageButtonPressed))
    lazy var secondImageButton = createButton(selector: #selector(chooseImageButtonPressed))
    lazy var thirdImageButton = createButton(selector: #selector(chooseImageButtonPressed))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editNavigationBar()
        tableView.backgroundColor = UIColor(white: 0.92, alpha: 1)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
    }
    
    fileprivate func editNavigationBar() {
        navigationItem.title = "Ayarlar"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signoutButtonPressed))
    }
    
    @objc fileprivate func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func signoutButtonPressed() {
        print("signout button handled")
    }
    
    @objc fileprivate func chooseImageButtonPressed(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.btnChooseImage = button
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[.originalImage] as? UIImage
        let btnChooseImage = (picker as? CustomImagePickerController)?.btnChooseImage
        btnChooseImage?.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
        btnChooseImage?.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true)
    }
    
    lazy var imagesArea: UIView = {
        let imagesArea = UIView()
        imagesArea.backgroundColor = .red
        
        imagesArea.addSubview(firstImageButton)
        
        _ = firstImageButton.anchor(top: imagesArea.topAnchor, bottom: imagesArea.bottomAnchor, leading: imagesArea.leadingAnchor, trailing: nil, padding: .init(top: 15, left: 15, bottom: 15, right: 0))
        firstImageButton.widthAnchor.constraint(equalTo: imagesArea.widthAnchor, multiplier: 0.42).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [secondImageButton, thirdImageButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        imagesArea.addSubview(stackView)
        
        _ = stackView.anchor(top: imagesArea.topAnchor, bottom: imagesArea.bottomAnchor, leading: firstImageButton.trailingAnchor, trailing: imagesArea.trailingAnchor, padding: .init(top: 15, left: 15, bottom: 15, right: 15))
        
        return imagesArea
    }()
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return imagesArea
        }
        
        let lblTitle = TitleLabel()
        switch section {
        case 1:
            lblTitle.text = "Name Surname"
        case 2:
            lblTitle.text = "Age"
        case 3:
            lblTitle.text = "Job Title"
        case 4:
            lblTitle.text = "About"
        default:
            lblTitle.text = ""
        }
        
        return lblTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.main.bounds.size.height*0.4
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProfileCell(style: .default, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Your name and surname"
        case 2:
            cell.textField.placeholder = "Your age"
        case 3:
            cell.textField.placeholder = "Your job title"
        case 4:
            cell.textField.placeholder = "About you"
        default:
            cell.textField.placeholder = ""
        }
        return cell
    }
}

class CustomImagePickerController: UIImagePickerController {
    var btnChooseImage: UIButton?
}


class TitleLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
}
