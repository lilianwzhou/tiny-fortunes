//
//  LoginViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class LoginViewController: UIViewController {

    var customView: AccountView? {
        return self.view as? AccountView
    }
    
    override func loadView() {
        self.view = AccountView()
    }
    
    override func viewDidLoad() {
        customView?.completeButton.setTitle("Login", for: .normal)
        customView?.completeButton.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        customView?.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
        
    }
    
    private func validateEmail() -> String? {
        guard let email = customView?.emailTextField.text, !email.isEmpty else {
            customView?.emailTextField.layer.borderColor = UIColor.red.cgColor
            customView?.emailTextField.layer.borderWidth = 3
            validatePassword()
            return nil
        }
        customView?.emailTextField.layer.borderWidth = 0
        return email
    }
    
    @discardableResult private func validatePassword() -> String? {
        guard let password = customView?.passwordTextField.text, !password.isEmpty else {
            customView?.passwordTextField.layer.borderColor = UIColor.red.cgColor
            customView?.passwordTextField.layer.borderWidth = 3
            return nil
        }
        customView?.passwordTextField.layer.borderWidth = 0
        return password
    }
    
    @objc private func loginAccount() {
        //with guard
        guard let email = validateEmail(), let password = validatePassword() else {
            return
        }
        
        authorizeUserAPICall(email: email, password: password)
        
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
                    self.customView?.showError(message: unwrappedError.localizedDescription)
                }
                return
            }
            
            guard let data = data, let resp = resp as? HTTPURLResponse else {
                //                DispatchQueue.main.async(execute: {
                //                    self.customView.showError(message: "Undefined Error")
                //                })
                DispatchQueue.main.async {
                    self.customView?.showError(message: "Undefined Error")
                }
                return
            }
            
            guard resp.statusCode == 200 else {
                DispatchQueue.main.async {
                    if let errorMessage = String(data: data, encoding: .utf8) {
                        self.customView?.showError(message: errorMessage)
                    }
                }
                return
            }
            
            if let object =  try? JSONDecoder().decode(AuthAPIResponse.self, from: data) {
                print(object)
                //print(object.jwt)
                DispatchQueue.main.async {
                    self.customView?.hideError()
                }
                // store ssomewhere? or call the auth endpoint with email and password to get JWT(the auth token to send with user related requests for verification)
                Networking.jwt = object.accessToken
                
                DispatchQueue.main.async {
                    let questionsVC = QuestionsViewController()
                    self.navigationController?.pushViewController(questionsVC, animated: true)
                }
            }
            
        })
        dataTask.resume()
    }
}
