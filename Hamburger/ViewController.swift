//
//  ViewController.swift
//  Hamburger
//
//  Created by Kurt Jensen on 10/12/16.
//  Copyright © 2016 Arbor Apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button = HamburgerButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.addTarget(self, action: #selector(ViewController.toggle), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    func toggle() {
        button.isMenu = !button.isMenu
    }

}

