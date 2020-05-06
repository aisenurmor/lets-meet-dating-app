//
//  SettingController.swift
//  letsMeet
//
//  Created by aisenur on 24.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage

class ProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: ProfileControllerDelegate?
    static let defaultMinAge = 18
    static let defaultMaxAge = 99
    
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
        tableView.backgroundColor = UIColor(white: 0.96, alpha: 1)
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        
        getUserDataFromFS()
    }
    
    var currentUser : User?
    fileprivate func getUserDataFromFS() {
        Firestore.firestore().getUserInformations { (user, err) in
            if let err = err {
                print(err)
                return
            }
            self.currentUser = user
            self.showUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func showUserPhotos() {
        if let imageURL = currentUser?.imageURL, let url = URL(string: imageURL) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.firstImageButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageURL = currentUser?.imageURL2, let url = URL(string: imageURL) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.secondImageButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        
        if let imageURL = currentUser?.imageURL3, let url = URL(string: imageURL) {
            SDWebImageManager.shared().loadImage(with: url, options: .continueInBackground, progress: nil) { (img, _, _, _, _, _) in
                self.thirdImageButton.setImage(img?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    fileprivate func editNavigationBar() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signoutButtonPressed)),
            UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        ]
    }
    
    @objc fileprivate func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func saveButtonPressed() {
        guard let uid = currentUser?.userId else {return}
        
        let info: [String: Any] = [
            "uuid": uid,
            "nameSurname": currentUser?.userName ?? "",
            "job": currentUser?.job ?? "",
            "age": currentUser?.age ?? -1,
            "imageURL": currentUser?.imageURL ?? "",
            "imageURL2": currentUser?.imageURL2 ?? "",
            "imageURL3": currentUser?.imageURL3 ?? "",
            "minAgeCriteria": currentUser?.minAgeCriteria ?? ProfileController.defaultMinAge,
            "maxAgeCriteria": currentUser?.maxAgeCriteria ?? ProfileController.defaultMaxAge
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Your informations are saving.."
        hud.show(in: view)
        
        Firestore.firestore().collection("Users").document(uid).setData(info) { (err) in
            hud.dismiss()
            
            if let err = err {
                print("Error \(err)")
                return
            }
            self.dismiss(animated: true) {
                self.delegate?.criteriasSaved()
            }
        }
    }
    
    @objc fileprivate func signoutButtonPressed() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
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
        
        let imageName = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/Images/\(imageName)")
        guard let data = img?.jpegData(compressionQuality: 0.8) else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Images are downloading.."
        hud.show(in: view)
        
        ref.putData(data, metadata: nil) { (_, err) in
            if err != nil {
                hud.dismiss()
                return
            }
            
            ref.downloadURL { (url, err) in
                hud.dismiss()
                if err != nil {
                    return
                }
                
                if btnChooseImage == self.firstImageButton {
                    self.currentUser?.imageURL = url?.absoluteString
                } else if btnChooseImage == self.secondImageButton {
                    self.currentUser?.imageURL2 = url?.absoluteString
                } else if btnChooseImage == self.thirdImageButton {
                    self.currentUser?.imageURL3 = url?.absoluteString
                }
            }
        }
    }
    
    lazy var imagesArea: UIView = {
        let imagesArea = UIView()
        
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
        case 5:
            lblTitle.text = "Age Range"
        default:
            lblTitle.text = ""
        }
        
        lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
        return lblTitle
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UIScreen.main.bounds.size.height*0.4
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            let ageRangeCell = AgeRangeCell(style: .default, reuseIdentifier: nil)
            ageRangeCell.minSlider.addTarget(self, action: #selector(minSliderValueChanged), for: .valueChanged)
            ageRangeCell.maxSlider.addTarget(self, action: #selector(maxSliderValueChanged), for: .valueChanged)
            
            let minAge = currentUser?.minAgeCriteria ?? ProfileController.defaultMinAge
            let maxAge = currentUser?.maxAgeCriteria ?? ProfileController.defaultMaxAge
            
            ageRangeCell.lblMin.text = "Min \(minAge)"
            ageRangeCell.lblMax.text = "Max \(maxAge)"
            ageRangeCell.minSlider.value = Float(minAge)
            ageRangeCell.maxSlider.value = Float(maxAge)
            
            return ageRangeCell
        }
        
        let cell = ProfileCell(style: .default, reuseIdentifier: nil)
       
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Your name and surname"
            cell.textField.text = currentUser?.userName
            cell.textField.addTarget(self, action: #selector(catchNameTextField), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Your age"
            cell.textField.keyboardType = .numberPad
            if let age = currentUser?.age {
                cell.textField.text = String(age)
            }
            cell.textField.addTarget(self, action: #selector(catchAgeTextField), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Your job title"
            cell.textField.text = currentUser?.job
            cell.textField.addTarget(self, action: #selector(catchJobTextField), for: .editingChanged)
        case 4:
            cell.textField.placeholder = "About you"
        //            cell.textField.addTarget(self, action: #selector(catchAboutTextField), for: .editingChanged)
        default:
            cell.textField.placeholder = ""
        }
        return cell
    }
    
    @objc fileprivate func minSliderValueChanged(slider: UISlider) {
        setMinMaxAge()
    }
    
    @objc fileprivate func maxSliderValueChanged(slider: UISlider) {
        setMinMaxAge()
    }
    
    fileprivate func setMinMaxAge() {
        guard let ageRangeCell = tableView.cellForRow(at: [5,0]) as? AgeRangeCell else { return }
        
        let minValue = Int(ageRangeCell.minSlider.value)
        var maxValue = Int(ageRangeCell.maxSlider.value)
        
        maxValue = max(minValue, maxValue)
        
        ageRangeCell.maxSlider.value = Float(maxValue)
        
        ageRangeCell.lblMin.text = "Min \(minValue)"
        ageRangeCell.lblMax.text = "Max \(maxValue)"
        
        currentUser?.minAgeCriteria = minValue
        currentUser?.maxAgeCriteria = maxValue
    }
    
    @objc fileprivate func catchNameTextField(textField: UITextField) {
        currentUser?.userName = textField.text
    }
    
    @objc fileprivate func catchAgeTextField(textField: UITextField) {
        currentUser?.age = Int(textField.text ?? "")
    }
    
    @objc fileprivate func catchJobTextField(textField: UITextField) {
        currentUser?.job = textField.text
    }
    
    //    @objc fileprivate func catchAboutTextField(textField: UITextField) {
    //        currentUser?.userName = textField.text
    //    }
}

class CustomImagePickerController: UIImagePickerController {
    var btnChooseImage: UIButton?
}


class TitleLabel: UILabel {
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 15, dy: 0))
    }
}

protocol ProfileControllerDelegate {
    func criteriasSaved()
}
