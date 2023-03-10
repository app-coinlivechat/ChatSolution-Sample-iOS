//
//  ViewController.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/04.
//

import UIKit
import CoinliveChatSDK

class SampleLoginViewController: UIViewController {
    private let API_KEY = "testsite"
    private var customer: Customer? = nil
    
    private let coinliveTitle: String = "Coinlive\nCHAT solution\nsample"
    private let coinliveDescription: String = "sample_description".localized()
    private var image: Data? = nil
    private var profileImageTextField: UITextField? = nil
    private var bandIdTextField: UITextField? = nil
    private var uuidTextField: UITextField? = nil
    private var nicknameTextField: UITextField? = nil
    private var coinliveRestApi: CoinliveRestApi = CoinliveRestApi()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSystemUi()
        initializeUi()
        initializeCustomerInfo()
    }
    
    private func initializeCustomerInfo() {
//        self.showActivityIndicator()
    }
    
    @objc func reloadInfo() {
        self.initializeCustomerInfo()
    }
    
    private func initializeSystemUi() {
        self.navigationController?.toolbar.isHidden = true
    }
    
    private func initializeUi() {
        view.backgroundColor = .background
        
        let titleLabel = self.createLabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.numberOfLines = 0
        
        let titleAttribute = NSMutableAttributedString(string: self.coinliveTitle)
        titleAttribute.setAttributes(
            [.foregroundColor: UIColor.label],
            range: (self.coinliveTitle as NSString).range(of: "Coinlive")
        )
        titleAttribute.setAttributes(
            [.foregroundColor: UIColor.primary],
            range: (self.coinliveTitle as NSString).range(of: "CHAT")
        )
        titleAttribute.setAttributes(
            [.foregroundColor: UIColor.label],
            range: (self.coinliveTitle as NSString).range(of: "solution sample")
        )
        
        let parahraphStyle = NSMutableParagraphStyle.init()
        titleAttribute.addAttributes([NSAttributedString.Key.paragraphStyle: parahraphStyle, NSAttributedString.Key.kern: 1.2], range: NSRange(location: 0, length: titleAttribute.length))
        titleLabel.attributedText = titleAttribute
        self.view.addSubview(titleLabel)
        
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.reloadInfo)))
        
        titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        
        let bandLine = self.createLineView(topAnchor: titleLabel.bottomAnchor, labelText: "BAND ID", textFieldBackgroundColor: .textFieldBackground, placeholderText: "Email", placeholderTextColor: .placeholderDark, button: nil, isBlockTextField: true)
        self.view.addSubview(bandLine.0)
        self.bandIdTextField = bandLine.1
        
        let refreshImage = UIImage(named: "ic_refresh")
        let refreshButton = UIButton(type: UIButton.ButtonType.custom)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setImage(refreshImage, for: .normal)
        refreshButton.addTarget(self, action: #selector(uuidRefresh), for: .touchUpInside)
        
        let uuidLine = self.createLineView(topAnchor: bandLine.0.bottomAnchor, labelText: "UUID", textFieldBackgroundColor: .textFieldBackground, placeholderText: "insert_uuid".localized(), placeholderTextColor: .placeholderDark, button: refreshButton)
        self.view.addSubview(uuidLine.0)
        self.uuidTextField = uuidLine.1
        
        let nicknameLine = self.createLineView(topAnchor: uuidLine.0.bottomAnchor, labelText: "Nickname", textFieldBackgroundColor: .textFieldBackground, placeholderText: "limit_insert_nickname".localized(), placeholderTextColor: .placeholderDark, button: nil)
        self.view.addSubview(nicknameLine.0)
        self.nicknameTextField = nicknameLine.1
        
        let chooseButton = self.createTextButton(title: "SELECT", backgroundColor: .primary, titleColor: .white, fontSize: 12)
        chooseButton.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        
        let profileImageLine = self.createLineView(topAnchor: nicknameLine.0.bottomAnchor, labelText: "Profile Image", textFieldBackgroundColor: .textFieldBackgroundDark, placeholderText: "limit_image_size".localized(), placeholderTextColor: .placeholderDark, button: chooseButton, isBlockTextField: false)
        self.view.addSubview(profileImageLine.0)
        self.profileImageTextField = profileImageLine.1
        
        let signUpButton = self.createTextButton(title: "sign_up".localized(), backgroundColor: .buttonInactive, titleColor: .white, fontSize: 14)
        signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        self.view.addSubview(signUpButton)
        
        let connectUserButton = self.createTextButton(title: "enter_user".localized(), backgroundColor: .buttonInactive, titleColor: .white, fontSize: 14)
        connectUserButton.addTarget(self, action: #selector(connectUser), for: .touchUpInside)
        self.view.addSubview(connectUserButton)
        
        connectUserButton.topAnchor.constraint(equalTo: profileImageLine.0.bottomAnchor, constant: 16).isActive = true
        connectUserButton.trailingAnchor.constraint(equalTo: profileImageLine.0.trailingAnchor, constant: -16).isActive = true
        connectUserButton.widthAnchor.constraint(equalToConstant: 81).isActive = true
        connectUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        signUpButton.centerYAnchor.constraint(equalTo: connectUserButton.centerYAnchor).isActive = true
        signUpButton.trailingAnchor.constraint(equalTo: connectUserButton.leadingAnchor, constant: -16).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 57).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let divider = UIView()
        divider.backgroundColor = .spaceLine
        divider.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(divider)
        
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.topAnchor.constraint(equalTo: connectUserButton.bottomAnchor, constant: 24).isActive = true
        divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        
        let connectUnknownUserButton = self.createTextButton(title: "enter_anonymous".localized(), backgroundColor: .buttonActive, titleColor: .white, fontSize: 14)
        self.view.addSubview(connectUnknownUserButton)
        
        connectUnknownUserButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24).isActive = true
        connectUnknownUserButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        connectUnknownUserButton.widthAnchor.constraint(equalToConstant: 81).isActive = true
        connectUnknownUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        connectUnknownUserButton.addTarget(self, action: #selector(connectUnknownUser), for: .touchUpInside)
        
        let descriptionLabel = UITextView()
        descriptionLabel.isEditable = false
        descriptionLabel.isScrollEnabled = true
        descriptionLabel.isUserInteractionEnabled = true
        descriptionLabel.textColor = .label
        descriptionLabel.textContainerInset = .init(top: 16.0, left: 40.0, bottom: 16.0, right: 40.0)
        descriptionLabel.dataDetectorTypes = .link
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        descriptionLabel.delegate = self
//        descriptionLabel.textAlignment = .center
        
        let centerParagraph = NSMutableParagraphStyle()
        centerParagraph.alignment = .center
        
        let descriptionAttribute = NSMutableAttributedString(string: self.coinliveDescription)
        descriptionAttribute.setAttributes(
            [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 14)
             , .paragraphStyle : centerParagraph
            ],
            range: (self.coinliveDescription as NSString).range(of: self.coinliveDescription)
        )
        descriptionAttribute.setAttributes(
            [.foregroundColor: UIColor.link, .underlineStyle: NSUnderlineStyle.single.rawValue, .font: UIFont.systemFont(ofSize: 14)
             , .paragraphStyle : centerParagraph
            ],
            range: (self.coinliveDescription as NSString).range(of: "app@coinlive.net")
        )
        
        descriptionLabel.attributedText = descriptionAttribute
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: connectUnknownUserButton.bottomAnchor, constant: 16).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        
        self.view.addSubview(self.indicatorView)
        self.indicatorView.isHidden = true
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        self.uuidTextField?.text = "iosUser100"
//        self.uuidRefresh()
        self.bandIdTextField?.text = self.API_KEY
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createLineView(topAnchor: NSLayoutYAxisAnchor, labelText: String, textFieldBackgroundColor: UIColor, placeholderText: String, placeholderTextColor: UIColor, button: UIButton?, isBlockTextField: Bool = true) -> (UIView, UITextField) {
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        let tagLabel = self.createLabel()
        tagLabel.font = UIFont.systemFont(ofSize: 16)
        tagLabel.textColor = .label
        tagLabel.text = labelText
        tagLabel.adjustsFontSizeToFitWidth = true
        lineView.addSubview(tagLabel)
        
        let textField = PaddingTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = textFieldBackgroundColor
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.borderWidth = 1.0
        textField.textColor = .label
        textField.layer.cornerRadius = 4.0
        textField.isEnabled = isBlockTextField
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: placeholderTextColor])
        lineView.addSubview(textField)
        
        self.view.addSubview(lineView)
        
        lineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        tagLabel.leadingAnchor.constraint(equalTo: lineView.leadingAnchor, constant: 16).isActive = true
        tagLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor).isActive = true
        tagLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 16).isActive = true
        textField.centerYAnchor.constraint(equalTo: lineView.centerYAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: lineView.trailingAnchor, constant: -16).isActive = true
        
        if let button = button {
            lineView.addSubview(button)
            button.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            button.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -9).isActive = true
            if let text = button.titleLabel?.text {
                if text == "SELECT" {
                    button.setTitle("select".localized(), for: .normal)
                    button.widthAnchor.constraint(equalToConstant: 41).isActive = true
                }
            }
        }
        
        return (lineView, textField)
    }
    
    private func showCustomAlert(title: String, alertActionDelegate: AlertActionDelegate? = nil) {
        let alert = SampleAlertViewController()
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        alert.alertDescription = title
        alert.alertActionDelegate = alertActionDelegate
        self.hideActivityIndicator()
        self.present(alert, animated: true, completion: nil)
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
    
    @objc func uuidRefresh() {
        self.uuidTextField?.text = self.randomString(length: Int.random(in: 8...12))
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc func chooseImage() {
        self.view.endEditing(true)
        print("> chooseImage")
        let imagePicker = UIImagePickerController()
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            self.present(imagePicker, animated: true , completion: nil)
        }
    }
    
    @objc func signUp() {
        self.view.endEditing(true)
        print("> signUp")
        
        guard let uuid = self.uuidTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.showCustomAlert(title: "insert_uuid".localized())
            return
        }
        
        let image = self.image
        self.showActivityIndicator()
        self.getCustomerInfo {
            self.getCustomToken(uuid: uuid) { customToken in
                self.signInWithCustomToken(customToken: customToken) { firebaseId in
                    self.checkMember(uuid: firebaseId) { status in
                        switch status {
                        case .NONE:
                            self.checkValidationNickname { availableNickname in
                                self.uploadProfileImage(image: image) { imageUrl in
                                    let url = imageUrl ?? self.customer?.image ?? ""
                                    self.customerUserSignUp(imageUrl: url, nickname: availableNickname) {
                                        self.showCustomAlert(title: "signup_success".localized(), alertActionDelegate: self)
                                    }
                                }
                            }
                            break
                        case .ACTIVE:
                            self.hideActivityIndicator()
                            self.showCustomAlert(title: "already_sign_up_user".localized())
                            break
                        case .BLOCK:
                            self.hideActivityIndicator()
                            self.showCustomAlert(title: "suspended_user".localized())
                            break
                        case .DORMANT:
                            self.hideActivityIndicator()
                            self.showCustomAlert(title: "dormant_user".localized())
                            break
                        case .INACTIVE:
                            self.hideActivityIndicator()
                            self.showCustomAlert(title: "inactive_user".localized())
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    @objc func connectUser() {
        self.view.endEditing(true)
        print("> connectUser")
        guard let uuid = self.uuidTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.showCustomAlert(title: "insert_uuid".localized())
            return
        }
        
        self.showActivityIndicator()
        self.getCustomerInfo {
            self.getCustomToken(uuid: uuid) { customToken in
                self.signInWithCustomToken(customToken: customToken) { firebaseId in
                    self.checkMember(uuid: firebaseId) { status in
                        self.hideActivityIndicator()
                        switch status {
                        case .NONE:
                            self.showCustomAlert(title: "no_user".localized())
                            break
                        case .ACTIVE:
                            // pass
                            self.showSelectChannelViewController()
                            break
                        case .BLOCK:
                            self.showCustomAlert(title: "suspended_user".localized())
                            break
                        case .DORMANT:
                            self.showCustomAlert(title: "dormant_user".localized())
                            break
                        case .INACTIVE:
                            self.showCustomAlert(title: "inactive_user".localized())
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    @objc func connectUnknownUser() {
        self.view.endEditing(true)
        print("> connectUnknownUser")
        
        self.showActivityIndicator()
        self.getCustomerInfo {
            self.signInWithUnknwonUser()
        }
    }
    
    func showActivityIndicator() {
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
    private func showSelectChannelViewController() {
        let sampleSelectChannelViewController = SampleSelectChannelViewController()
        sampleSelectChannelViewController.customerName = self.customer!.nickname
        self.navigationController?.pushViewController(sampleSelectChannelViewController, animated: true)
    }
    
    private func getCustomerInfo(callback: @escaping() -> ()) {
        self.coinliveRestApi
            .getCustomerInfo(
                name: self.bandIdTextField?.text ?? "",
                onSuccess: { customer in
                    self.customer = customer
                    self.bandIdTextField?.text = self.customer?.nickname
                    callback()
                },
                onFailed: { error in
                    self.showCustomAlert(title: "load_fail".localized())
                    self.hideActivityIndicator()
                })
    }
    
    private func checkCustomerInfo() -> Bool {
        let isLoadedCustomerInfo = customer == nil
        if isLoadedCustomerInfo {
            self.showCustomAlert(title: "check_api_key".localized())
        }
        return isLoadedCustomerInfo
    }
    
    private func checkMember(uuid: String, checkMemberCallback: @escaping(_ userStatus: USER_STATUS) -> Void) {
        self.coinliveRestApi.signUpCheck(firebaseUuid: uuid,
                                         onSuccess: { response in
            checkMemberCallback(response.status!)
        },
                                         onFailed: { error in
            self.hideActivityIndicator()
            self.showCustomAlert(title: error.message)}
        )
    }
    
    private func checkValidationNickname(checkNicknameCallback: @escaping(_ nickname: String) -> Void) {
        guard let nickname = self.nicknameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.showCustomAlert(title: "insert_nickname".localized())
            self.hideActivityIndicator()
            return
        }
        
        if nickname.trimmingCharacters(in: .whitespacesAndNewlines).count > 10 {
            self.showCustomAlert(title: "limit_insert_nickname_comment".localized())
            self.hideActivityIndicator()
            return
        }
        
        self.coinliveRestApi.isAvailableNickname(nickname: nickname,
                                                 customerId: self.customer!.customerId,
                                                 onSuccess: { _ in checkNicknameCallback(nickname) },
                                                 onFailed: { error in
            self.hideActivityIndicator()
            self.showCustomAlert(title: error.message)
        }
        )
    }
    
    private func uploadProfileImage(image: Data?, uploadProfileImageCallback: @escaping(_ imageUrl: String?) -> Void) {
        if image == nil {
            self.hideActivityIndicator()
            uploadProfileImageCallback(nil)
            return
        }
        
        print("> uploadProfileImage")
        self.coinliveRestApi.uploadProfileImage(image: image!,
                                                onSuccess: { imageResponse in uploadProfileImageCallback(imageResponse.url)},
                                                onFailed: { error in
            self.hideActivityIndicator()
            
        }
        )
    }
    
    private func customerUserSignUp(imageUrl: String, nickname: String, customerUserSignUpCallback: @escaping() -> Void) {
        print("> customerUserSignUp")
        self.coinliveRestApi.customerUserSignUp(customerId: self.customer!.customerId,
                                                profileImage: imageUrl,
                                                nickname: nickname,
                                                onSuccess: { customerUserSignUpCallback() },
                                                onFailed: { error in self.hideActivityIndicator() }
        )
    }
    
    private func getCustomToken(uuid: String, customTokenCallback: @escaping(_ customToken: String) -> Void) {
        self.coinliveRestApi.getCustomToken(
            apiKey: self.API_KEY, uuid: uuid, customerName: self.customer?.nickname ?? "",
            onSuccess: { response in customTokenCallback(response.customToken) },
            onFailed: { error in
                self.showCustomAlert(title: error.message)
                self.hideActivityIndicator()
            }
        )
    }
    
    private func signInWithCustomToken(customToken: String, signInWithCustomTokenCallback: @escaping(_ firebaseId: String) -> Void) {
        print("> signInWithCustomToken")
        CoinliveAuthentication.shared.signInWithCustomToken(customerName: self.customer?.nickname ?? "", customToken: customToken, signInCallback: {(firebaseId, error) in
            if let error = error {
                print(">>> error : \(error)")
                self.hideActivityIndicator()
            } else {
                signInWithCustomTokenCallback(firebaseId!)
            }
            
        })
    }
    
    private func signInWithUnknwonUser() {
        print("> signInWithUnknwonUser")
        CoinliveAuthentication.shared.signInWithUnknownUser(customerName: self.customer?.nickname ?? "", signInCallback: {(firebaseId, error) in
            if let _ = error {
                print(">>> error : \(error)")
                self.hideActivityIndicator()
            } else {
                self.hideActivityIndicator()
                self.showSelectChannelViewController()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

extension SampleLoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imageExtension = imageUrl.pathExtension
            var imageData: Data? = nil
            if imageExtension.uppercased() == "JPEG" {
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                imageData = image.jpegData(compressionQuality: 0.7)
            } else if imageExtension.uppercased() == "PNG" {
                let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
                imageData = image.pngData()
            } else {
                self.showCustomAlert(title: "insert_image_comment".localized())
                return
            }
            self.profileImageTextField?.text = imageUrl.lastPathComponent
            self.image = imageData
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension SampleLoginViewController: AlertActionDelegate {
    func cancel() {
        self.showSelectChannelViewController()
    }
}

extension SampleLoginViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        return false
    }
}
