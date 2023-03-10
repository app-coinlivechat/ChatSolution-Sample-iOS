//
//  Extension.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/04.
//

import UIKit

extension UIColor {
    class var primary: UIColor { return UIColor(named: "primary")! }
    class var background: UIColor { return UIColor(named: "background")! }
    class var buttonActive: UIColor { return UIColor(named: "button_active")! }
    class var buttonInactive: UIColor { return UIColor(named: "button_inactive")! }
    class var buttonPrimary: UIColor { return UIColor(named: "button_primary")! }
    class var labelLink: UIColor { return UIColor(named: "label_link")! }
    class var label: UIColor { return UIColor(named: "label")! }
    class var placeholderDark: UIColor { return UIColor(named: "placeholder_dark")! }
    class var placeholderLight: UIColor { return UIColor(named: "placeholder_light")! }
    class var spaceLine: UIColor { return UIColor(named: "space_line")! }
    class var textFieldBackgroundDark: UIColor { return UIColor(named: "textfield_background_dark")! }
    class var textFieldBackground: UIColor { return UIColor(named: "textfield_background")! }
    class var textFieldBorder: UIColor { return UIColor(named: "textfield_border")! }
    class var alertBackground: UIColor { return UIColor(named: "alert_background")! }
    class var alertText: UIColor { return UIColor(named: "alert_text")! }
    class var backgroundChannel: UIColor { return UIColor(named: "background_channel")! }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}
