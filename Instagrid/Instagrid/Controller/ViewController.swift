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
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var firstLayoutSelected: UIButton!
    @IBOutlet weak var secondLayoutSelected: UIButton!
    @IBOutlet weak var thirdLayoutSelected: UIButton!
    @IBOutlet weak var labelForSwipe: UILabel!


    @IBAction func firstLayout(_ sender: Any) {
        topRightButton.isHidden = true
        bottomRightButton.isHidden = false
        firstLayoutSelected.setImage(UIImage(named: "Selected"), for: .selected)

    }
    @IBAction func secondLayout(_ sender: Any) {
        topRightButton.isHidden = false
        bottomRightButton.isHidden = true
        secondLayoutSelected.setImage(UIImage(named: "Selected"), for: .selected)

    }
    @IBAction func thirdLayout(_ sender: Any) {
        topRightButton.isHidden = false
        bottomRightButton.isHidden = false
        thirdLayoutSelected.setImage(UIImage(named: "Selected"), for: .selected)
        
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



