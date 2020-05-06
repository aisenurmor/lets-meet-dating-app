//
//  RegisterViewModel.swift
//  letsMeet
//
//  Created by aisenur on 20.04.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewModel {
    
    var bindableRegistering = Bindable<Bool>()
    
    var bindableImage = Bindable<UIImage>()
    
    var bindableIsValidRegisterFields = Bindable<Bool>()
    
    var email: String? {
        didSet {
            isValidControl()
        }
    }
    var nameSurname: String? {
        didSet {
            isValidControl()
        }
    }
    var password: String? {
        didSet {
            isValidControl()
        }
    }
    
    func isValidControl() {
        let isValid = isValidEmail(email) && nameSurname?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsValidRegisterFields.value = isValid
    }
    
    func userRegister(completion: @escaping (Error?) -> ()) {
        
        guard let emailAddress = email, let password = password else { return }
        bindableRegistering.value = true
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (result, err) in
            if let err = err {
                completion(err)
                return
            }
        }
        
        saveImageToFirebase(completion: completion)
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        //User image upload to storage
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/Images/\(imageName)")
        let imageData = bindableImage.value?.jpegData(compressionQuality: 0.8) ?? Data()
        
        ref.putData(imageData, metadata: nil) { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            
            ref.downloadURL { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableRegistering.value = false
                print("Image url: \(String(describing: url))")
                
                let imageURL = url?.absoluteString ?? ""
                self.saveUserInformationsToFirestore(imgURL: imageURL, completion: completion)
            }
            
        }
    }
    
    fileprivate func saveUserInformationsToFirestore(imgURL: String, completion: @escaping (Error?) -> ()) {
        let userId = Auth.auth().currentUser?.uid ?? ""
        
        let data: [String : Any] = [
            "uuid": userId,
            "nameSurname": nameSurname ?? "",
            "imageURL": imgURL,
            "age": 18,
            "minAge": ProfileController.defaultMinAge,
            "maxAge": ProfileController.defaultMaxAge
            ]
        
        Firestore.firestore().collection("Users").document(userId).setData(data) { (err) in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
}
