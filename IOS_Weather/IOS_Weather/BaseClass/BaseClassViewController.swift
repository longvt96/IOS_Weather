//
//  BaseClassViewController.swift
//  IOS_Weather
//
//  Created by ThanhLong on 4/6/18.
//  Copyright © 2018 ThanhLong. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseClassViewController: UIViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showLoadingOnParent() {
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", messageFont: nil,
                       type: NVActivityIndicatorType(rawValue: 23)!,
                       color: UIColor.brown, padding: 0, displayTimeThreshold: 0,
                       minimumDisplayTime: 0,
                       backgroundColor: .clear, textColor: UIColor.red)
    }

    func hidenLoading() {
        stopAnimating()
    }
}
