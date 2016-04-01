//
//  ReplyViewController.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/03/31.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import UIKit

protocol ReplyViewControllerDelegate: class {
    func replyViewControllerDidSend(controller: ReplyViewController)
}

class ReplyViewController: UIViewController {

    var story: JSON = []
    var comment: JSON = []
    
    @IBOutlet weak var replyTextView: UITextView!
    
    weak var delegate: ReplyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        replyTextView.becomeFirstResponder()
    }
    
    @IBAction func sendButtonDidTouch(sender: AnyObject) {
        view.showLoading()
        let token = LocalStore.getToken()!
        let body = replyTextView.text
        
        if let storyId = story["id"].int {
            DNService.replyStoryWithId(storyId, token: token, body: body, response: { (successful) -> () in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            })
        }
        
        if let commentId = comment["id"].int {
            DNService.replyCommentWithId(commentId, token: token, body: body, response: { (successful) -> () in
                self.view.hideLoading()
                if successful {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.replyViewControllerDidSend(self)
                } else {
                    self.showAlert()
                }
            })
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Oh noes.", message: "Something went wrong. Your message wasn't sent. Try again and save your text just in case.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
