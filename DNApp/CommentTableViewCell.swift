//
//  CommentTableViewCell.swift
//  DNApp
//
//  Created by 永尾　正史 on 2016/02/17.
//  Copyright © 2016年 Meng To. All rights reserved.
//

import UIKit

protocol CommentTableViewCellDelegate: class {
    func commentTableViewCellDidTouchUpvote(cell: CommentTableViewCell)
    func commentTableViewCellDidTouchComment(cell: CommentTableViewCell)
}

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upvoteButton: SpringButton!
    @IBOutlet weak var replyButton: SpringButton!
    @IBOutlet weak var commentTextView: AutoTextView!
    weak var delegate: CommentTableViewCellDelegate?
    
    @IBAction func upvoteButtonDidTouch(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchUpvote(self)
    }
    
    @IBAction func replyButtonDidTouch(sender: AnyObject) {
        delegate?.commentTableViewCellDidTouchComment(self)
    }
    
    
    func configureWithComment(comment: JSON) {
        let userPortraitUrl = comment["user_portrait_url"].string
        let userDisplayName = comment["user_display_name"].string!
        let userJob = comment["user_job"].string ?? ""
        let createdAt = comment["created_at"].string!
        let voteCount = comment["vote_count"].int!
        let body = comment["body"].string!
//        let bodyHTML = comment["body_html"].string ?? ""
        
        avatarImageView.url = userPortraitUrl?.toURL()
        avatarImageView.placeholderImage = UIImage(named: "content-avatar-default")
        authorLabel.text = userDisplayName + ", " + userJob
        timeLabel.text = timeAgoSinceDate(dateFromString(createdAt, format: "yyyy-MM-dd'T'HH:mm:ssZ"), numericDates: true)
        upvoteButton.setTitle(String(voteCount), forState: UIControlState.Normal)
        commentTextView.text = body
//        commentTextView.attributedText = htmlToAttributedString(bodyHTML + "<style>*{font-family:\"Avenir Next\";font-size:16px;line-height:20px}img{max-width:300px}</style>")
        
        let commentId = comment["id"].int!
        if LocalStore.isCommentUpvoted(commentId) {
            upvoteButton.setImage(UIImage(named: "icon-upvote-active"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount+1), forState: UIControlState.Normal)
        } else {
            upvoteButton.setImage(UIImage(named: "icon-upvote"), forState: UIControlState.Normal)
            upvoteButton.setTitle(String(voteCount), forState: UIControlState.Normal)
        }
    }
}