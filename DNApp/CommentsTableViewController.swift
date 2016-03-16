//
//  CommentsTableViewController.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/02/09.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController, CommentTableViewCellDelegate, StoryTableViewCellDelegate {
    
    var story: JSON!
    var comments: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = story["comments"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifer = indexPath.row == 0 ? "StoryCell" : "CommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(identifer) as UITableViewCell!
        
        if let storyCell = cell as? StoryTableViewCell {
            storyCell.configureWithStory(story)
            storyCell.delegate = self
        }
        
        if let commentCell = cell as? CommentTableViewCell {
            let comment = comments[indexPath.row - 1]
            commentCell.configureWithComment(comment)
            commentCell.delegate = self
        }
        
        return cell
    }
    
    // MARK: CommentTableViewCellDelegate
    
    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell) {
        if let token = LocalStore.getToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let comment = comments[indexPath.row-1]
            let commentId = comment["id"].int!
            DNService.upvoteCommentWithId(commentId, token: token, response: { (successful) -> () in
                // Do someting
            })
            LocalStore.saveUpvotedComment(commentId)
            cell.configureWithComment(comment)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell) {
        
    }
    
    // MARK: StoryTableViewCellDelegate
    
    func storyTableViewCellDidTouchUpvote(cell: StoryTableViewCell, sender: AnyObject) {
        if let token = LocalStore.getToken() {
            let indexPath = tableView.indexPathForCell(cell)!
            let storyId = story["id"].int!
            DNService.upvoteStoryWithId(storyId, token: token, response: { (successful) -> () in
                // Do something
            })
            
            LocalStore.saveUpvotedStory(storyId)
            cell.configureWithStory(story)
        } else {
            performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    func storyTableViewCellDidTouchComment(cell: StoryTableViewCell, sender: AnyObject) {
        
    }
}