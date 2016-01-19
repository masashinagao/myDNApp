//
//  MenuViewController.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/01/19.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var dialogView: DesignableView!
    
    @IBAction func closeButtonDidTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        dialogView.animation = "fall"
        dialogView.animate()
    }
    
}
