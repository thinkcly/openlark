//
//  HomeViewController.swift
//  openlark
//
//  Created by AlexChen on 2021/09/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .gray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let url = URL(string: "feishu://") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
