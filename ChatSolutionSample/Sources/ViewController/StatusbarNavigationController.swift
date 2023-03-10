//
//  StatusbarNavigationController.swift
//  CoinliveChatSample
//
//  Created by Parkjonghyun on 2022/12/22.
//

import UIKit

class StatusbarNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        if let topVC = viewControllers.last {
            //return the status property of each VC, look at step 2
            return topVC.preferredStatusBarStyle
        }
        
        return .default
    }
}
