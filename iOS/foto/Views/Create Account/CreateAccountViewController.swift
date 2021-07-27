//
//  CreateAccountViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-24.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    private var customView: AccountView {
        return self.view as! AccountView
    }
    
    
    override func loadView() {
        super.loadView()
        self.view = AccountView()
    }
    
    override func viewDidLoad() {
        customView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        customView.completeButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        
    }
    
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func createAccount() {
        
        //with guard
        guard let email = customView.emailTextField.text, !email.isEmpty else {
            customView.emailTextField.layer.borderColor = UIColor.red.cgColor
            customView.emailTextField.layer.borderWidth = 3
            return
        }
        customView.emailTextField.layer.borderWidth = 0
        
        
        //without guard -> no email variable
        //        if customView.emailTextField.text == nil || customView.emailTextField.text?.isEmpty == true {
        //            customView.emailTextField.layer.borderColor = UIColor.red.cgColor
        //            customView.emailTextField.layer.borderWidth = 3
        //            return
        //        }
        
        guard let password = customView.passwordTextField.text, !password.isEmpty else {
            customView.passwordTextField.layer.borderColor = UIColor.red.cgColor
            customView.passwordTextField.layer.borderWidth = 3
            return
        }
        customView.passwordTextField.layer.borderWidth = 0
        createUserAPICall(email: email, password: password)
    }
    
    private func createUserAPICall(email: String, password: String) {
        //API CALL
        guard var request = Networking.getRequestFor(route: .user, method: .POST) else {
            return
        }
        
        
        
        //        JSONSerialization.data(withJSONObject: dict, options: [])
        guard let encodedStuff = try? JSONEncoder().encode(User(email: email, password: password)) else {
            return
        }
        
        request.httpBody = encodedStuff
        
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
            
            //BACKGROUNF THREADF
            
            if let unwrappedError = error {
                // At this point, we have an error
                DispatchQueue.main.async {
                    self.customView.showError(message: unwrappedError.localizedDescription)
                }
                return
            }
            
            guard let data = data, let resp = resp as? HTTPURLResponse else {
                //                DispatchQueue.main.async(execute: {
                //                    self.customView.showError(message: "Undefined Error")
                //                })
                DispatchQueue.main.async {
                    self.customView.showError(message: "Undefined Error")
                }
                return
            }
            
            guard resp.statusCode == 200 else {
                DispatchQueue.main.async {
                    if let errorMessage = String(data: data, encoding: .utf8) {
                        self.customView.showError(message: errorMessage)
                    }
                }
                return
            }
            
            if let object =  try? JSONDecoder().decode(CreateUserAPIResponse.self, from: data) {
                print(object)
                print(object.id)
                DispatchQueue.main.async {
                    self.customView.hideError()
                }
                // store somewhere? or call the auth endpoint with email and password to get JWT(the auth token to send with user related requests for verification)
                self.authorizeUserAPICall(email: email, password: password)
            }
            
        })
        
        dataTask.resume()
    }
    
    private func authorizeUserAPICall(email: String, password: String) {
        //API CALL
        guard var request = Networking.getRequestFor(route: .auth, method: .POST) else {
            return
        }
        
        //        JSONSerialization.data(withJSONObject: dict, options: [])
        guard let encodedStuff = try? JSONEncoder().encode(User(email: email, password: password)) else {
            return
        }
        
        request.httpBody = encodedStuff
        
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
            
            if let unwrappedError = error {
                // At this point, we have an error
                DispatchQueue.main.async {
                    self.customView.showError(message: unwrappedError.localizedDescription)
                }
                return
            }
            
            guard let data = data, let resp = resp as? HTTPURLResponse else {
                //                DispatchQueue.main.async(execute: {
                //                    self.customView.showError(message: "Undefined Error")
                //                })
                DispatchQueue.main.async {
                    self.customView.showError(message: "Undefined Error")
                }
                return
            }
            
            guard resp.statusCode == 200 else {
                DispatchQueue.main.async {
                    if let errorMessage = String(data: data, encoding: .utf8) {
                        self.customView.showError(message: errorMessage)
                    }
                }
                return
            }
            
            if let object =  try? JSONDecoder().decode(CreateUserAPIResponse.self, from: data) {
                print(object)
                //print(object.jwt)
                DispatchQueue.main.async {
                    self.customView.hideError()
                }
                // store somewhere? or call the auth endpoint with email and password to get JWT(the auth token to send with user related requests for verification)
            }
            
        })
        
        dataTask.resume()
    }
}
struct CreateUserAPIResponse: Codable {
    let id: String
}
