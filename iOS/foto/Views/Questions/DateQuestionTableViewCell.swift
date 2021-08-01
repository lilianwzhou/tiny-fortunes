//
//  DateQuestionTableViewCell.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-31.
//

import UIKit

protocol DateQuestionTableViewCellDelegate: AnyObject {
    func didSelectDate(date: Date?, row: Int)
}
class DateQuestionTableViewCell: UITableViewCell {
    
    weak var delegate: DateQuestionTableViewCellDelegate?
    var info: CellInfo? {
        didSet {
            guard let info = info else {
                return
            }
            updateViewFor(info: info)
        }
    }
    let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .appBodyFont
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let border = UIView()

    var stackViewHeightAnchor: NSLayoutConstraint?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
    
        backgroundColor = .white
        contentView.addSubview(questionLabel)
        contentView.addSubview(datePicker)
        
        
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .black
        
        
        backgroundColor = .white
        contentView.addSubview(questionLabel)
        contentView.addSubview(border)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            datePicker.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor, constant: 10),
            datePicker.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            border.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: datePicker.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
        
        datePicker.addTarget(self, action: #selector(changedDate), for: .editingChanged)
    }
    
    private func updateViewFor(info: CellInfo) {
        
        guard case .date(let date) = info.cellType else {
            return
        }
        questionLabel.text = info.prompt
        
        if let date = date {
            datePicker.date = date
        }
    }
    
    @objc private func changedDate() {
        delegate?.didSelectDate(date: datePicker.date, row: tag)
    }
}
