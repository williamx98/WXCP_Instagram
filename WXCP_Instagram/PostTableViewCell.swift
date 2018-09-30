//
//  PostTableViewCell.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 8/27/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: Post!
    var liked = false
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.delegate = self
        self.postImageView.isUserInteractionEnabled = true;
        self.postImageView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func doubleTapped() {
        if (self.liked == false) {
            post.likesCount = post.likesCount + 1
            let likeCount = likeCountLabel.text!
            likeCountLabel.text = String(Int(likeCount) ?? 0 + 1)
            post.saveInBackground()
            self.yourFunctionWhichDoesNotHaveASender()
            self.liked = true;
        }
    }
    
    weak var delegate: CustomCellUpdater?
    
    func yourFunctionWhichDoesNotHaveASender () {
            delegate?.updateTableView()
    }
}

protocol CustomCellUpdater: class { // the name of the protocol you can put any
    func updateTableView()
}
