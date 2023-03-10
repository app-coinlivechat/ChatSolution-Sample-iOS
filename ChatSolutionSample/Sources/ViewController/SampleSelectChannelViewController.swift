//
//  CoinliveChatViewController.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/10.
//

import UIKit
import CoinliveChatSDK
import CoinliveChatUIKit

class SampleSelectChannelViewController: UIViewController {
    private let API_KEY = "testsite"
    private let CUSTOMER_NAME = "testsite"
    private var channelList: Array<(Bool, Channel)> = []
    private var tvChannel: UITableView? = nil
    private var coinliveRestApi: CoinliveRestApi = CoinliveRestApi()
    internal var customerName: String!
    private var isClicked: Bool = false
    private lazy var indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.color = .primary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        initializeSystemUi()
        initializeUi()
    }
    
    private func initializeData() {
        self.showActivityIndicator()
        self.coinliveRestApi
            .getChannelList(name: self.CUSTOMER_NAME,
                            onSuccess: { channelList in
                self.channelList = channelList.map { (false, $0) }
                self.tvChannel?.reloadData()
                self.hideActivityIndicator()
            },onFailed: { error in
                print(error)
                self.hideActivityIndicator()
            })
    }
    
    private func initializeSystemUi() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.font = UIFont.systemFont(ofSize: 16)
        
        label.text = "select_channel".localized()
        label.numberOfLines = 1
        label.textColor = .label
        label.sizeToFit()
        label.textAlignment = .center
        
        self.navigationItem.titleView = label
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "common_confirm".localized(), style: .plain, target: self, action: #selector(clickConfirm))
        self.navigationItem.rightBarButtonItem?.tintColor = .primary
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        if #available(iOS 16.0, *) {
            self.navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
    
    private func initializeUi() {
        self.view.backgroundColor = .background
        self.tvChannel = UITableView()
        tvChannel?.translatesAutoresizingMaskIntoConstraints = false
        tvChannel?.separatorStyle = .none
        tvChannel?.allowsSelection = true
        
        tvChannel?.delegate = self
        tvChannel?.dataSource = self
        self.view.addSubview(tvChannel!)
        
        tvChannel?.register(SampleChannelRowCell.classForCoder(), forCellReuseIdentifier: "ChannelRowCell")
        
        tvChannel?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tvChannel?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tvChannel?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tvChannel?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.addSubview(self.indicatorView)
        self.indicatorView.isHidden = true
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    @objc func clickConfirm() {
        if self.isClicked {
            return
        }
        self.showActivityIndicator()
        guard let selectedItemIndex = self.checkSelectedItem() else {
            self.showCustomAlert(title: "choose_channel".localized())
            self.hideActivityIndicator()
            return
        }
        let channel = self.channelList[selectedItemIndex].1
        self.showCoinliveChat(channel: channel)
    }
    
    private func showCoinliveChat(channel: Channel) {
        let coinliveChatViewController = CoinliveChatViewController()
        coinliveChatViewController.channel = channel
        coinliveChatViewController.customerName = self.customerName
        self.loadMemberInformation { user in
            coinliveChatViewController.customerUser = user
            self.navigationController?.pushViewController(coinliveChatViewController, animated: true)
            self.hideActivityIndicator()
        }
    }
    
    func showActivityIndicator() {
        self.isClicked = true
        self.indicatorView.isHidden = false
        self.indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideActivityIndicator() {
        self.isClicked = false
        self.indicatorView.stopAnimating()
        self.indicatorView.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
    private func checkSelectedItem() -> Int? {
        var selectedIndex: Int?
        self.channelList.map { $0.0 }.enumerated().forEach {
            if $1 {
                selectedIndex = $0
            }
        }
        return selectedIndex
    }
    
    private func showCustomAlert(title: String, alertActionDelegate: AlertActionDelegate? = nil) {
        let alert = SampleAlertViewController()
        alert.modalTransitionStyle = .crossDissolve
        alert.modalPresentationStyle = .overFullScreen
        alert.alertDescription = title
        alert.alertActionDelegate = alertActionDelegate
        self.present(alert, animated: true, completion: nil)
    }
    
    private func loadMemberInformation(callback: @escaping(_ customerUser: CustomerUser?) -> ()) {
        if CoinliveAuthentication.shared.isAnonymousUser() {
            callback(nil)
            self.hideActivityIndicator()
        } else {
            coinliveRestApi.getCustomerMemberInfo(
                onSuccess: { customerUser in
                    callback(customerUser)
                },
                onFailed: { error in
                    print(error)
                    self.hideActivityIndicator()
                })
        }
    }
}

extension SampleSelectChannelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvChannel!.dequeueReusableCell(withIdentifier: "ChannelRowCell", for: indexPath) as! SampleChannelRowCell
        cell.selectionStyle = .none
        
        let item = self.channelList[indexPath.row]
        cell.loadCellData(isSelected: item.0, item: item.1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectIndex = indexPath.row
        let preSelectedIndex: Int? = self.checkSelectedItem()
        
        self.channelList[selectIndex].0 = !self.channelList[selectIndex].0
        
        if let preSelectedIndex = preSelectedIndex {
            if preSelectedIndex != selectIndex {
                self.channelList[preSelectedIndex].0 = !self.channelList[preSelectedIndex].0
                self.tvChannel?.reloadRows(at: [IndexPath(row: preSelectedIndex, section: 0)], with: .none)
            }
        }
        self.tvChannel?.reloadRows(at: [indexPath], with: .none)
    }
}
