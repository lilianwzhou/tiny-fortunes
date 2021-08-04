//
//  OpenQuestionTableViewCell.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-30.
//

import UIKit

class OpenQuestionTableViewCell: UITableViewCell {
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .appBodyFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answerField: UITextField = {
        let answer = UITextField()
        answer.font = .appBodyFont
        answer.textColor = .black
        answer.translatesAutoresizingMaskIntoConstraints = false
        return answer
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .black
        
        
        backgroundColor = .white
        contentView.addSubview(questionLabel)
        contentView.addSubview(answerField)
        contentView.addSubview(border)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            answerField.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor, constant: 10),
            answerField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            answerField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            border.bottomAnchor.constraint(equalTo: answerField.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: answerField.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: answerField.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
        
        
        
    }
}
