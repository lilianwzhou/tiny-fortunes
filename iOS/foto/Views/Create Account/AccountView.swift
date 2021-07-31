//
//  CreateAccountView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-24.
//

import UIKit

class AccountView: UIView {
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = .appBodyFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = .appBodyFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding(horizontalPadding: 20)
        textField.placeholder = "johnappleseed@gmailcom"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextFieldWithPadding = {
        let textField = UITextFieldWithPadding(horizontalPadding: 20)
        textField.placeholder = "supersecretawesomepassword"
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let sunImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "sun"))
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let header: UILabel = {
        let header = UILabel()
        header.text = "fortune\ncookie."
        header.numberOfLines = 2
        header.font = .headerFont
        header.textColor = .black
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    let completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .appBodyFont
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26, weight: .regular)), for: .normal)
        button.imageView?.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let errorLabel: UILabel = {
        let error = UILabel()
        error.textColor = .red
        error.font = .appBodyFont
        error.translatesAutoresizingMaskIntoConstraints = false
        return error
    }()
    
    private var errorHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            
        //MY CUSTOM SHIT
        backgroundColor = .white
        addSubview(header)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(sunImage)
        addSubview(completeButton)
        addSubview(backButton)
        addSubview(errorLabel)
        
        print(subviews)
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 65),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailLabel.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 18),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 9),
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 19),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 9),
            sunImage.leadingAnchor.constraint(equalTo: header.trailingAnchor),
            sunImage.bottomAnchor.constraint(equalTo: header.topAnchor, constant: 15),
            sunImage.heightAnchor.constraint(equalToConstant: 30),
            sunImage.widthAnchor.constraint(equalToConstant: 30),
            completeButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            completeButton.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 70),
            backButton.widthAnchor.constraint(equalToConstant: 70),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            errorLabel.topAnchor.constraint(equalTo: completeButton.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            backButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 42)
        ])
        
        errorHeightConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorHeightConstraint?.isActive = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(gestureRecognizer)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    func showError(message: String) {
        errorLabel.text = message
        errorHeightConstraint?.constant = 20
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
        
    }
    
    func hideError() {
        errorHeightConstraint?.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}


import SwiftUI

struct ControllerPreview: PreviewProvider {
    static var previews: some View {
        Group {
            ContainerView()
            ContainerView()
        }
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = CreateAccountViewController
        
        func makeUIViewController(context: Context) -> CreateAccountViewController {
            return CreateAccountViewController()
        }
        
        func updateUIViewController(_ uiViewController: CreateAccountViewController, context: Context) {
            
        }
    }
}
