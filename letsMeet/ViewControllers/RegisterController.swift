//
//  RegisterController.swift
//  letsMeet
//
//  Created by aisenur on 17.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegisterController: UIViewController {
    
    let btnPhotos: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select Photo", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 15
        
        btn.heightAnchor.constraint(equalToConstant: 200).isActive = true
        btn.imageView?.contentMode = .scaleAspectFill
        
        btn.addTarget(self, action: #selector(btnPhotosPressed), for: .touchUpInside)
        
        return btn
    }()
    
    let txtEmail: LetsMeetTextField = {
        let txt = LetsMeetTextField(padding: 15, placeholder: "Email address")
        txt.keyboardType = .emailAddress
        txt.autocapitalizationType = .none
        
        txt.addTarget(self, action: #selector(onChangeTextField), for: .editingChanged)
        
        return txt
    }()
    
    let txtNameSurname: LetsMeetTextField = {
        let txt = LetsMeetTextField(padding: 15, placeholder: "Name Surname")
        txt.autocapitalizationType = .words
        
        txt.addTarget(self, action: #selector(onChangeTextField), for: .editingChanged)
        
        return txt
    }()
    
    let txtPassword: LetsMeetTextField = {
        let txt = LetsMeetTextField(padding: 15, placeholder: "Password")
        txt.isSecureTextEntry = true
        txt.autocapitalizationType = .none
        
        txt.addTarget(self, action: #selector(onChangeTextField), for: .editingChanged)
        
        return txt
    }()
    
    let btnRegister: UIButton = {
        let btn = UIButton(type: .system)
        
        btn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        
        btn.isEnabled = false
        
        btn.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        
        return btn
    }()
    
    let gradient = CAGradientLayer()
    let registerViewModel = RegisterViewModel()
    let registerHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient()
        editLayout()
        
        createNotificationObserver()
        
        addTapGesture()
        
        createRegisterViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.frame = view.bounds
    }
    
    //MARK: - Register Operations
    @objc fileprivate func registerButtonPressed() {
        closeKeyboard()
        
        registerViewModel.userRegister { (err) in
            if let err = err {
                self.errorAlert(err: err)
                return
            }
            print("User registered with successful.")
        }
    }
    
    fileprivate func errorAlert(err: Error) {
        registerHUD.dismiss(animated: true)
        
        let hud = JGProgressHUD(style: .dark)
        
        hud.textLabel.text = "Registration Failed"
        hud.detailTextLabel.text = err.localizedDescription
        
        hud.show(in: self.view, animated: true)
        hud.dismiss(afterDelay: 3, animated: true)
    }
    
    //MARK: - Register ViewModel Observer
    fileprivate func createRegisterViewModelObserver() {
        registerViewModel.bindableIsValidRegisterFields.assignValue { (isValid) in
            
            guard let isValid = isValid else { return }
            self.btnRegister.isEnabled = isValid
            
            if isValid {
                self.btnRegister.backgroundColor = #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1)
                self.btnRegister.setTitleColor(.white, for: .normal)
                
            } else {
                self.btnRegister.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                self.btnRegister.setTitleColor(.gray, for: .normal)
            }
        }
        
        registerViewModel.bindableImage.assignValue { (imgProfile) in
            self.btnPhotos.setImage(imgProfile?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        registerViewModel.bindableRegistering.assignValue { (registerStatus) in
            if registerStatus == true {
                self.registerHUD.textLabel.text = "Your account creating..."
                self.registerHUD.show(in: self.view)
            } else {
                self.registerHUD.dismiss()
            }
        }
    }
    
    //MARK: - TextInput onChange
    @objc fileprivate func onChangeTextField(textField: UITextField) {
        if textField == txtEmail {
            registerViewModel.email = txtEmail.text
        } else if textField == txtNameSurname {
            registerViewModel.nameSurname = txtNameSurname.text
        } else if textField == txtPassword {
            registerViewModel.password = txtPassword.text
        }
    }
    
    //MARK: - Keyboard closing process
    fileprivate func addTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeKeyboard)))
    }
    
    @objc fileprivate func closeKeyboard() {
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    //MARK: - Detect keyboard opening or closing
    fileprivate func createNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(catchOpenKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(catchCloseKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func catchCloseKeyboard(notification: Notification) {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        }, completion: nil)
    }
    
    @objc fileprivate func catchOpenKeyboard(notification: Notification) {
        guard let keyboardFinishValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFinishFrame = keyboardFinishValue.cgRectValue
        
        let bottomSpace = view.frame.height - (registerSV.frame.origin.y + registerSV.frame.height)
        let tolerence = (keyboardFinishFrame.height - bottomSpace) + 10
        
        if tolerence < 0 {
            return
        }
        
        self.view.transform = CGAffineTransform(translationX: 0, y: -tolerence)
    }
    
    //MARK: - btnPhotosPressed Operations
    @objc fileprivate func btnPhotosPressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - Layout adjustments
    lazy var verticalSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            txtEmail,
            txtNameSurname,
            txtPassword,
            btnRegister
        ])
        sv.axis = .vertical
        sv.spacing = 10
        sv.distribution = .fillEqually
        
        return sv
    }()
    
    lazy var registerSV = UIStackView(arrangedSubviews: [
        btnPhotos,
        verticalSV
    ])
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.verticalSizeClass == .compact {
            registerSV.axis = .horizontal
        } else {
            registerSV.axis = .vertical
        }
    }
    
    fileprivate func editLayout() {
        view.addSubview(registerSV)
        
        registerSV.axis = .vertical
        
        btnPhotos.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        registerSV.spacing = 10
        
        _ = registerSV.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: view.bounds.width*0.08, bottom: 0, right: view.bounds.width*0.08))
        registerSV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        registerSV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setBackgroundGradient() {
        let firstColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        let secondColor = #colorLiteral(red: 0.2352941176, green: 0.2509803922, blue: 0.7764705882, alpha: 1)
        
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
}

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImg = info[.originalImage] as? UIImage
        registerViewModel.bindableImage.value = chosenImg
        
        dismiss(animated: true, completion: nil)
    }
}
