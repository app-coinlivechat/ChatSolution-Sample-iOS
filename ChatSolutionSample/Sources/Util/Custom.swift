//
//  Custom.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/04.
//

import UIKit

class PaddingTextField: UITextField {
    let padding = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 60);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
