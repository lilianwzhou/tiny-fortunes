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
            
            DispatchQueue.main.async {
                self.customView.showError(message: "THERE IS A FAT ERROR")
            }
            
            if let data = data {
                print(data)
                print(String(data: data, encoding: .utf8))
            }
            
            if let error = error {
                print(error)
            }
            
            if let resp = resp {
                print(resp)
            }
        })
        
        dataTask.resume()
    }
}
