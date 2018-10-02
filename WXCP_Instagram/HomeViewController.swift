//
//  HomeViewController.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 8/27/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit
import Parse
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCellUpdater {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var posts: [Post] = []
    let headerViewIdentifier = "headerViewIdentifier"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = PFUser.current()?.username
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 500
        tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        self.getPosts()
    }
    
    // Hides the RefreshControl
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.getPosts()
    }
    
    func getPosts() {
        let query = Post.query()
        query?.includeKey("author")
        query?.limit = 20
        query?.addDescendingOrder("createdAt")
        query?.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let posts = posts {
                self.posts = posts as! [Post]
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                if (posts.count == 0) {
                    self.tableView.isHidden = true
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = self.posts[indexPath.section]
        let postImage = post.media as PFFile
        postImage.getDataInBackground{ (imageData: Data?, error: Error?) in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    cell.postImageView.image = image
                }
            }
        }
        cell.descriptionLabel.text = post.caption
        cell.likeCountLabel.text = String(post.likesCount)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.post = post
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as! UITableViewHeaderFooterView
        let post = self.posts[section]
        let postTime = post.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd.yyyy hh:mm"
        let date = formatter.string(from: postTime ?? Date())
        header.textLabel?.text = (post.author.username ?? "user") + "    " + date
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func updateTableView() {
        tableView.reloadData() // you do have an outlet of tableView I assume
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PostDetailViewController {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell) {
                let post = self.posts[indexPath.section]
                dest.post = post
                //dest.dateLabel.text = date
            }
        }
    }
}
