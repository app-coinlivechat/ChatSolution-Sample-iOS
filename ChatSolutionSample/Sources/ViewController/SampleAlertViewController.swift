//
//  CustomAlertViewController.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/04.
//

import UIKit

protocol AlertActionDelegate {
    func cancel()
}

class SampleAlertViewController: UIViewController {
    public var alertDescription: String? = nil
    public var alertActionDelegate: AlertActionDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        let alertView = UIView()
        alertView.layer.cornerRadius = 16
        alertView.backgroundColor = .alertBackground
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        let alertDescriptionLabel = self.createLabel()
        alertDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        alertDescriptionLabel.textColor = .alertText
        alertDescriptionLabel.text = alertDescription
        alertDescriptionLabel.numberOfLines = 0
        alertDescriptionLabel.textAlignment = .center
        
        alertView.addSubview(alertDescriptionLabel)
        
        let confirmButton = self.createTextButton(title: "확인", backgroundColor: .primary, titleColor: .white, fontSize: 16)
        confirmButton.layer.cornerRadius = 12
        confirmButton.addTarget(self, action: #selector(self.closeAlert), for: .touchUpInside)
        
        alertView.addSubview(confirmButton)
        self.view.addSubview(alertView)
        
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: 311).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 148).isActive = true
        
        alertDescriptionLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 24).isActive = true
        alertDescriptionLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        alertDescriptionLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        
        confirmButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20).isActive = true
        
        
    }
    
    private func createTextButton(title: String, backgroundColor: UIColor, titleColor: UIColor, fontSize: CGFloat) -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.textColor = titleColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.layer.cornerRadius = 5.0
        return button
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    @objc func closeAlert() {
        self.dismiss(animated: true) {
            self.alertActionDelegate?.cancel()
        }
    }
}
