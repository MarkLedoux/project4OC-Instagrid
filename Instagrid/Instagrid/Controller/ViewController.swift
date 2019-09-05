//
//  ViewController.swift
//  Instagrid
//
//  Created by Mark LEDOUX on 20/08/2019.
//  Copyright © 2019 Mark LEDOUX. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var image = UIImage(named: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ViewController.deviceOrientationForSwipeToShare(deviceOrientation:)), name: UIDevice.orientationDidChangeNotification, object: nil)

    }

    //MARK: bottoms buttons actions
    //TODO: reference the buttons for the layout change as an array of outlets and find how to get them to fire individually
    @IBOutlet weak var labelForSwipe: UILabel!

    @IBOutlet var collectionOfButtonToChangeLayout: [UIButton]!
    @IBOutlet var pictureView: PictureGridView!

    @IBAction func firstLayout(_ sender: Any) {
        pictureView.buttonInPictureGridView[0].isHidden = true
        pictureView.buttonInPictureGridView[3].isHidden = false
    }
    @IBAction func secondLayout(_ sender: Any) {
        pictureView.buttonInPictureGridView[0].isHidden = false
        pictureView.buttonInPictureGridView[3].isHidden = true
    }
    @IBAction func thirdLayout(_ sender: Any) {
        pictureView.buttonInPictureGridView[0].isHidden = false
        pictureView.buttonInPictureGridView[3].isHidden = false
    }

    //MARK: GridView buttons actions
    @IBAction func openPhotoLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)

        }

    }
    
    @IBAction func shareImage(_ sender: UISwipeGestureRecognizer) {
        let image = UIImage(named: "")
        let imageToShare = [image!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc func deviceOrientationForSwipeToShare(deviceOrientation: UIDeviceOrientation) {
        if deviceOrientation.isPortrait {
            labelForSwipe.text = "Swipe up to share"
        } else if deviceOrientation.isLandscape {
            labelForSwipe.text = "Swipe left to share"
        }
    }

}



