//
//  AddCaptionViewController.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 9/25/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class AddCaptionViewController: UIViewController {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var refreshingIndicator: UIActivityIndicatorView!
    
    
    var postImage: UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        postImageView.image = postImage
        captionField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCancelPress(_ sender: Any) {
        (self.parent as! UINavigationController).tabBarController?.selectedIndex = 0
        dismiss(animated: false, completion: nil)
    }
    
    
    
    @IBAction func onSubmitPress(_ sender: Any) {
        refreshingIndicator.startAnimating()
        Post.postUserImage(image: self.postImage, withCaption: self.captionField.text) { (success: Bool?, error: Error?) in
            if (success!) {
                print("posted")
                self.navigationController?.popViewController(animated: false)
                self.performSegue(withIdentifier: "detailToHome", sender: self)
            } else {
                print(error?.localizedDescription ?? "this is bad")
            }
            self.refreshingIndicator.stopAnimating()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
