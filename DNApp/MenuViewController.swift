//
//  MenuViewController.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/01/19.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func menuViewControllerDidTouchTop(controller: MenuViewController)
    func menuViewControllerDidTouchRecent(controller: MenuViewController)
}

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    weak var delegate: MenuViewControllerDelegate?
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "fall"
        dialogView.animate()
    }
    
    @IBAction func topButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchTop(self)
        closeButtonDidTouch(sender)
    }
    
    @IBAction func recentButtonDidTouch(sender: AnyObject) {
        delegate?.menuViewControllerDidTouchRecent(self)
        closeButtonDidTouch(sender)
    }
    @IBAction func loginButtonDidTouch(sender: AnyObject) {
    }
}
