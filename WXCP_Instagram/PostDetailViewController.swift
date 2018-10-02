//
//  PostDetailViewController.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 9/30/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UITextView!
    
    var post: Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(post)
        authorLabel.text = post.author.username
        let postTime = post.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy hh:mm"
        let date = formatter.string(from: postTime ?? Date())
        dateLabel.text = String(date)
        likesLabel.text = String(post.likesCount)
        captionLabel.text = post.caption
        let postImage = post.media as PFFile
        postImage.getDataInBackground{ (imageData: Data?, error: Error?) in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    self.postImageView.image = image
                }
            }
        }
    }
}
