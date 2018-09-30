//
//  PhotoMapViewController.swift
//  WXCP_Instagram
//
//  Created by Will Xu  on 8/27/18.
//  Copyright © 2018 Will Xu . All rights reserved.
//

import UIKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var editedImage: UIImage!
    @IBOutlet weak var getFromCamera: UIButton!
    @IBOutlet weak var getFromGallery: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.showImagePicker()
    }
    
    @IBAction func getFromCameraPressed(_ sender: Any) {
        self.getImage();
    }
    
    @IBAction func getFromGalleryPressed(_ sender: Any) {
        self.showImagePicker()
    }
    
    
    func getImage() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            self.showCamera()
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            self.showImagePicker()
        }
    }
    
    func showCamera() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .camera
        self.present(vc, animated: true, completion: nil)
    }
    
    func showImagePicker() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = .photoLibrary
        self.present(vc, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        editedImage = info[UIImagePickerControllerEditedImage] as! UIImage

        dismiss(animated: false, completion: {
            self.performSegue(withIdentifier: "editSegue", sender: nil)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AddCaptionViewController {
            dest.postImage = editedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        (self.parent as! UINavigationController).tabBarController?.selectedIndex = 0
        dismiss(animated: true, completion: nil)
    }
}
