//
//  WelcomeView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class WelcomeView: UIView {
    
    let header: UILabel = {
        let header = UILabel()
        let image = NSTextAttachment()
        image.image = UIImage(systemName: "figure.walk")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26
                                                                                                        , weight: .regular))
        let finalString = NSMutableAttributedString(string: "TINY \n FORTUNES \n", attributes: [.baselineOffset: -5])
        finalString.insert(NSAttributedString(attachment: image), at: 4)
        header.attributedText = finalString
//        header.adjustsFontSizeToFitWidth = true
//        header.minimumScaleFactor = 0.5
        header.numberOfLines = 0
        header.font = .headerFont
        header.textColor = .black
        header.lineBreakMode = .byWordWrapping
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
//    let manImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "figure.walk")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26, weight: .regular))
//        imageView.tintColor = .black
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let createAccountButton: UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .appBodyFont
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    let createLoginButton: UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 25
        button.titleLabel?.font = .appBodyFont
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(header)
        // addSubview(manImage)
        addSubview(createAccountButton)
        addSubview(createLoginButton)
    
        
        header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        
       //  manImage.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: -140)
        
        
        createAccountButton.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createAccountButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        createAccountButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        createAccountButton.topAnchor.constraint(equalTo: centerYAnchor, constant: 80).isActive = true

        
        createLoginButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 30).isActive = true
        createLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        createLoginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        createLoginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        createLoginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
    }
    
//    completeButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
//    completeButton.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
//    completeButton.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
//    completeButton.heightAnchor.constraint(equalToConstant: 50),

    
}


