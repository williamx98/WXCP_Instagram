//
//  ProfileViewController.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 10/1/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse
class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var posts: [Post] = []
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.current()?.username
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine:CGFloat = 3
        let interSpace = layout.minimumInteritemSpacing * (cellsPerLine - 1)
        let width = (collectionView.frame.size.width/cellsPerLine) - (interSpace/cellsPerLine)
        layout.itemSize = CGSize(width: width, height: width * (3/2))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        self.getPosts()
    }
    
    func getPosts() {
        let query = Post.query()
        query?.includeKey("author")
        query?.whereKey("author", equalTo: PFUser.current())
        query?.limit = 20
        query?.addDescendingOrder("createdAt")
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts as! [Post]
                self.collectionView.reloadData()
                
                if (posts.count == 0) {
                    self.collectionView.isHidden = true
                    let alertController = UIAlertController(title: "No posts found", message:
                        "Upload photos to see them in the feed!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))

                    self.present(alertController, animated: true, completion: nil)
                }
                

            } else {
                print(error?.localizedDescription ?? "Seeing this is bad")
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "thumbCell", for: indexPath) as! thumbCell
        let post = posts[indexPath.item]
        let postImage = post.media as PFFile
        postImage.getDataInBackground{ (imageData: Data?, error: Error?) in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    cell.thumbImage.image = image
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        performSegue(withIdentifier: "profileToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PostDetailViewController {
            let post = posts[self.selectedIndex]
            dest.post = post
        }
    }
}
