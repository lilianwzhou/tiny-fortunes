//
//  UITextFieldWithPadding.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-24.
//

import UIKit

class UITextFieldWithPadding: UITextField {
    var horizontalPadding: CGFloat
    
    convenience init(horizontalPadding: CGFloat) {
        self.init(frame: .zero)
        self.horizontalPadding = horizontalPadding
    }
    
    override init(frame: CGRect) {
        self.horizontalPadding = 0
        super.init(frame: frame)
        
        font = .appBodyFont
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 25
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalPadding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
