//
//  FortuneView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-30.
//

import UIKit

class FortuneView: UIView {
    
    let header: UILabel = {
        let header = UILabel()
        header.text = "TINY\n FORTUNES"
        header.adjustsFontSizeToFitWidth = true
        header.minimumScaleFactor = 0.5
        header.numberOfLines = 2
        header.font = .headerFont
        header.textColor = .black
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "face.smiling")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)), for: .normal)
        button.imageView?.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cookieImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "cookie"))
        view.tintColor = .black
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let messageLabel: UILabel = {
        let label =  UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.textColor = .black
        label.font = .appBodyFont
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(header)
        addSubview(profileButton)
        addSubview(cookieImage)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            header.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            profileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            profileButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -75),
            cookieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            cookieImage.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 30),
            cookieImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            messageLabel.topAnchor.constraint(equalTo: cookieImage.bottomAnchor, constant: 20)
        
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
