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
        customView.createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
    
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

        //API CALL
        guard let url = URL(string: "localhost:3000/user") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST" 
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
            
            if let error = error {
                print(error)
            }
            
            if let resp = resp {
                print(resp)
            }
        })
        }
}
