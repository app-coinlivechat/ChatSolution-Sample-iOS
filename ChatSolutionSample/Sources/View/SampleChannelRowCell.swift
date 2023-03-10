//
//  ChannelRowCell.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/11/10.
//

import UIKit
import CoinliveChatSDK

class SampleChannelRowCell: UITableViewCell {
    private var ivSymbol: UIImageView!
    private var lbSymbol: UILabel!
    private var lbName: UILabel!
    private var btnSelect: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUi()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUi()
    }
    
    private func initializeUi() {
        let symbolSize = 42.0
        self.ivSymbol = UIImageView()
        
        self.ivSymbol.translatesAutoresizingMaskIntoConstraints = false
        self.ivSymbol.layer.cornerRadius = symbolSize / 2
        self.addSubview(ivSymbol)
        
        self.ivSymbol.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.ivSymbol.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.ivSymbol.widthAnchor.constraint(equalToConstant: symbolSize).isActive = true
        self.ivSymbol.heightAnchor.constraint(equalToConstant: symbolSize).isActive = true
        
        self.lbSymbol = UILabel()
        self.lbSymbol.translatesAutoresizingMaskIntoConstraints = false
        
        self.lbSymbol.font = UIFont.boldSystemFont(ofSize: 20)
        self.lbSymbol.textColor = .label
        self.addSubview(self.lbSymbol)
        
        self.lbSymbol.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.lbSymbol.leadingAnchor.constraint(equalTo: self.ivSymbol.trailingAnchor, constant: 10.0).isActive = true
        
        self.lbName = UILabel()
        self.lbName.translatesAutoresizingMaskIntoConstraints = false
        
        self.lbName.textColor = .label
        self.lbName.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.lbName)
        
        self.lbName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.lbName.leadingAnchor.constraint(equalTo: self.lbSymbol.trailingAnchor, constant: 8.0).isActive = true
        
        self.btnSelect = UIButton()
        self.btnSelect.translatesAutoresizingMaskIntoConstraints = false
        self.btnSelect.setImage(UIImage(named: "ic_check_inactive"), for: .normal)
        self.btnSelect.setImage(UIImage(named: "ic_check_active"), for: .selected)
        self.btnSelect.isUserInteractionEnabled = false
        self.addSubview(self.btnSelect)
        
        self.btnSelect.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.btnSelect.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
    }
    
    func loadCellData(isSelected: Bool, item: Channel) {
        if let iconUrlString = item.iconUrl, let url = URL(string: iconUrlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
                    self.ivSymbol.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
        self.lbSymbol.text = item.symbol
        self.lbName.text = item.name
        self.btnSelect.isSelected = isSelected
        if isSelected {
            self.backgroundColor = .backgroundChannel
        } else {
            self.backgroundColor = .background
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ivSymbol.image = nil
    }
}
