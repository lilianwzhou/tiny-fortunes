//
//  DropDownQuestionTableViewCell.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-30.
//

import UIKit

protocol DropdownQuestionTableViewCellDelegate: AnyObject {
    func didSelect(value: String?, row: Int)
}
class DropdownQuestionTableViewCell: UITableViewCell {
    
    weak var delegate: DropdownQuestionTableViewCellDelegate?
    
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
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.backgroundColor = .white
        stack.layer.cornerRadius = 10
        stack.layer.cornerCurve = .continuous
        stack.layer.masksToBounds = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layer.shadowOpacity = 0.2
        stack.layer.shadowOffset = .zero
        stack.layer.shadowRadius = 5
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        return stack
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
        contentView.addSubview(stackView)
        
        
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = .black
        
        
        backgroundColor = .white
        contentView.addSubview(questionLabel)
        contentView.addSubview(border)
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            border.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            border.heightAnchor.constraint(equalToConstant: 1),
            border.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
        
//        stackViewHeightAnchor = stackView.heightAnchor.constraint(equalToConstant: 30)
        
//        stackViewHeightAnchor?.isActive = true
        
    }
    
    private func updateViewFor(info: CellInfo) {
        
        questionLabel.text = info.prompt
        
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        if info.cellType.isExpanded() {
            info.items.forEach { item in
                optionView(title: item, isSelected: info.cellType.currentSelected() == item)
            }
            stackViewHeightAnchor?.constant = CGFloat(info.items.count * 30)
            stackView.layer.shadowColor = UIColor.black.cgColor
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
            UIView.animate(withDuration: 0.3) {
                self.border.alpha = 0
            }
        } else {
            optionView(title: info.cellType.currentSelected() ?? "None", justLabel: true)
            stackViewHeightAnchor?.constant = 30
            stackView.directionalLayoutMargins = .zero
            stackView.layer.shadowColor = UIColor.clear.cgColor
            UIView.animate(withDuration: 0.3) {
                self.border.alpha = 1
            }
        }

        layoutIfNeeded()
    }
    
    private func optionView(title: String, isSelected: Bool = false, justLabel: Bool = false)  {
        let view = UIView()
        
        view.backgroundColor = !justLabel && isSelected ? .systemBlue : .clear
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        
        var stackSubview: UIView
        
        if justLabel {
            let label = UILabel()
            label.textColor = .black
            label.text = title
            label.font = .appBodyFont
            stackSubview = label
        } else {
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(isSelected ? .white : .black, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = isSelected ? .appBodyBold : .appBodyFont
            button.addTarget(self, action: #selector(handleButtonTapped(sender:)), for: .touchUpInside)
            stackSubview = button
        }
        
        stackSubview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackSubview)
        

    
        stackView.addArrangedSubview(view)
        NSLayoutConstraint.activate([
            stackSubview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: justLabel ? 0 : 12),
            stackSubview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: justLabel ? 0 : -12),
            stackSubview.topAnchor.constraint(equalTo: view.topAnchor, constant: justLabel ? 0 : 5),
            stackSubview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: justLabel ? 0 : -5),
            view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: justLabel ? 0 : 5),
            view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: justLabel ? 0 : -5)
        ])
        
        
        
    }
    
    @objc private func handleButtonTapped(sender: UIButton) {
        guard let title = sender.titleLabel?.text else {
            return
        }
        
        for view in stackView.arrangedSubviews {
            view.backgroundColor = .clear
            if let button = view.subviews.compactMap({$0 as? UIButton}).first {
                button.titleLabel?.font = .appBodyFont
                button.setTitleColor(.black, for: .normal)
            }
        }
        if title == info?.cellType.currentSelected() {
            delegate?.didSelect(value: nil, row: tag)
        } else {
            sender.titleLabel?.font = .appBodyBold
            sender.setTitleColor(.white, for: .normal)
            sender.superview?.backgroundColor = .systemBlue
            delegate?.didSelect(value: title, row: tag)
        }
        
    }
}

struct CellInfo {
    let keyName: String
    var prompt: String
    var cellType: CellType
    
    var items: [String] {
        switch cellType {
        case .boolean:
            return ["Yes", "No"]
        case .dropdown(let items, _, _):
            return items
        default:
            return []
        }
    }
}

enum CellType {
    case open
    case boolean(isExpanded: Bool, currentSelected: Bool?)
    case dropdown(items: [String], isExpanded: Bool, currentSelected: String?)
    
    func isDropdown() -> Bool {
        switch self {
        case .boolean, .dropdown:
            return true
        default:
            return false
        }
    }
    
    func isExpanded() -> Bool {
        switch self {
        case .boolean(let i, _):
            return i
        case .dropdown(_, let i, _):
            return i
        default:
            return false
        }
    }
    
    func select() -> CellType {
        switch self {
        case .boolean(let isExpanded, let current):
            return .boolean(isExpanded: !isExpanded, currentSelected: current)
        case .dropdown(let e, let i, let c):
            return .dropdown(items: e, isExpanded: !i, currentSelected: c)
        case .open:
            return .open
        }
    }
    
    func currentSelected() -> String? {
        switch self {
        case .boolean(_, let i):
            if let i = i {
                return i ? "Yes" : "No"
            }
            return nil
        case .dropdown(_, _, let c):
            return c
        default:
            return nil
        }
        
    }
}
