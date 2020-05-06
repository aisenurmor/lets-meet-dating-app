//
//  LoginController.swift
//  letsMeet
//
//  Created by aisenur on 30.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import JGProgressHUD

class LoginController: UIViewController {
    
    var delegate : LoginControllerDelegate?
    fileprivate let sessionVM = SessionViewModel()
    fileprivate let sessionHUD = JGProgressHUD(style: .dark)
    
    var userEmail: String? {
        didSet {
            txtEmail.text = userEmail
        }
    }
    
    let txtEmail: LetsMeetTextField = {
        let txt = LetsMeetTextField(padding: 15, placeholder: "Email Address", height: 55)
        txt.keyboardType = .emailAddress
        txt.autocapitalizationType = .none
        txt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        return txt
    }()
    
    let txtPassword: LetsMeetTextField = {
        let txt = LetsMeetTextField(padding: 15, placeholder: "Password", height: 55)
        txt.isSecureTextEntry = true
        txt.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        return txt
    }()
    
    let loginBtn: LetsMeetButton = {
        let btn = LetsMeetButton(title: "Sign In", height: nil)
        btn.addTarget(self, action: #selector(loginBtnClicked), for: .touchUpInside)
        
        return btn
    }()
    
    let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Back to Register Screen", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        btn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var stackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [
            txtEmail,
            txtPassword,
            loginBtn
       ])
        
        sv.axis = .vertical
        sv.spacing = 10
        
        return sv
    }()
    
    @objc fileprivate func textFieldChanged(textField: UITextField) {
        print(textField)
        if textField == txtEmail {
            sessionVM.email = textField.text
        } else {
            sessionVM.password = textField.text
        }
    }
    
    @objc fileprivate func loginBtnClicked(btn: UIButton) {
        sessionVM.signin { (err) in
            self.sessionHUD.dismiss()
            if let err = err {
                print(err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            self.delegate?.doneLogin()
        }
    }
    
    @objc fileprivate func backBtnClicked(btn: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient()
        editLayout()
        
        createBindable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        gradient.frame = view.bounds
    }
    
    fileprivate func createBindable() {
        
        sessionVM.formIsValid.assignValue { (isValid) in
            guard let isValid = isValid else { return }
            self.loginBtn.isEnabled = isValid
            
            if isValid {
                self.loginBtn.backgroundColor = #colorLiteral(red: 0.2, green: 0.8509803922, blue: 0.6980392157, alpha: 1)
                self.loginBtn.setTitleColor(.white, for: .normal)
                
            } else {
                self.loginBtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                self.loginBtn.setTitleColor(.gray, for: .normal)
            }
        }
        
        sessionVM.loggingIn.assignValue { (loggingIn) in
            if loggingIn == true {
                self.sessionHUD.textLabel.text = "Logging in.."
                self.sessionHUD.show(in: self.view)
            } else {
                self.sessionHUD.dismiss()
            }
        }
    }
    
    fileprivate func setBackgroundGradient() {
        let firstColor = #colorLiteral(red: 0.9450980392, green: 0.9490196078, blue: 0.9647058824, alpha: 1)
        let secondColor = #colorLiteral(red: 0.2352941176, green: 0.2509803922, blue: 0.7764705882, alpha: 1)
        
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.bounds
    }
    
    fileprivate func editLayout() {
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(stackView)
        _ = stackView.anchor(top: nil, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: view.bounds.width*0.08, bottom: 0, right: view.bounds.width*0.08))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(backBtn)
        _ = backBtn.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
    }
}

protocol LoginControllerDelegate {
    func doneLogin()
}
