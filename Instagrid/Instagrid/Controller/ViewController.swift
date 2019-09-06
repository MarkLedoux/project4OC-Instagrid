//
//  ViewController.swift
//  Instagrid
//
//  Created by Mark LEDOUX on 20/08/2019.
//  Copyright © 2019 Mark LEDOUX. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var newPic: Bool?
    @IBOutlet var imageView: UIButton!
    @IBOutlet var imageView2: UIButton!
    @IBOutlet var imageView3: UIButton!
    @IBOutlet var imageView4: UIButton!

    @IBOutlet weak var labelForSwipe: UILabel!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet var collectionOfButtonToChangeLayout: [UIButton]!
    @IBOutlet var buttonInPictureGridView: [UIButton]!
    @IBOutlet var pictureView: PictureGridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(deviceOrientationChanged), name: Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)

        checkInterfaceOrientation(interfaceOrientation: UIApplication.shared.statusBarOrientation)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(shareImage(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }

    //MARK: bottoms buttons actions
    //TODO: figure out how to place the Selected image according to the button without having to reference the spot and size specific CGRect

    //    @IBAction func buttonLayoutDidGetTapped(_ sender: UIButton) {
    //        UIButton.animate(withDuration: 0.2,animations: {
    //            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
    //                         completion: { finish in
    //                            UIButton.animate(withDuration: 0.2, animations: {
    //                                sender.transform = CGAffineTransform.identity})
    //        })
    //    let firstPictureViewButton = buttonInPictureGridView[0]
    //    let thirdPictureViewButton = buttonInPictureGridView[3]
    //
    //        switch sender.tag {
    //        case 0:
    //            // for the left button, concerning layout 1
    //            hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
    //            sender.isSelected = true
    //
    //            disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 1, isSelected: false)
    //        case 1:
    //            // for the middle button, concerning layout 2
    //            hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
    //            sender.isSelected = true
    //
    //            disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 2, isSelected: false)
    //        case 2:
    //            // for the right button, concerning layout 3
    //            hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
    //            sender.isSelected = true
    //
    //            disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 3, isSelected: false)
    //        default:
    //            break
    //
    //        }
    //
    //    }


    @IBAction func firstLayout(_ sender: UIButton) {
        //only works on XS Max
        let button = UIButton(frame: CGRect(x: 42.3, y: 757, width: 80, height: 80))
        button.addTarget(self, action: #selector(touchesEnded(_:with:)), for: .touchUpInside)
        button.isExclusiveTouch = true
        button.setBackgroundImage(UIImage(named: "Selected"), for: .normal)
        button.setImage(UIImage(named: "Selected"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        view.addSubview(button)
        dismiss(animated: true, completion: nil)

        UIButton.animate(withDuration: 0.2,animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity})
        })
        buttonInPictureGridView[0].isHidden = true
        pictureView.buttonInPictureGridView[3].isHidden = false

    }
    @IBAction func secondLayout(_ sender: UIButton) {
        let button = UIButton(frame: CGRect(x: 167, y: 757, width: 80, height: 80))
        button.addTarget(self, action: #selector(touchesEnded(_:with:)), for: .touchUpInside)
        button.isExclusiveTouch = true
        button.setBackgroundImage(UIImage(named: "Selected"), for: .normal)
        button.setImage(UIImage(named: "Selected"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        view.addSubview(button)

        UIButton.animate(withDuration: 0.2,animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity})
        })
        pictureView.buttonInPictureGridView[0].isHidden = false
        pictureView.buttonInPictureGridView[3].isHidden = true
    }
    @IBAction func thirdLayout(_ sender: UIButton) {
        let button = UIButton(frame: CGRect(x: 291.67, y: 757, width: 80, height: 80))
        button.addTarget(self, action: #selector(touchesEnded(_:with:)), for: .touchUpInside)
        button.isExclusiveTouch = true
        button.setBackgroundImage(UIImage(named: "Selected"), for: .normal)
        button.setImage(UIImage(named: "Selected"), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        view.addSubview(button)

        UIButton.animate(withDuration: 0.2,animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity})
        })
        pictureView.buttonInPictureGridView[0].isHidden = false
        pictureView.buttonInPictureGridView[3].isHidden = false
    }

    //MARK: GridView buttons actions
    
    @IBAction func shareImage(_ sender: UISwipeGestureRecognizer) {
        let image = imagePicked
        let imageToShare = [image!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }

    //MARK: methods to open the camera or the photo library
    @IBAction func buttonTapped(_ sender: UIButton) {
        let myAlert = UIAlertController(title: "Select Image from", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
        }
        let cameraRollAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        self.present(myAlert, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            imageView.setBackgroundImage(UIImage(named: "Plus"), for: .normal)
            imageView.setImage(image, for: .normal)

            if newPic == true {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save failed", message: "Failed to save image", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }

    }

    //MARK: methods to checks for device and for interface orientation when the app launches and when the app is running
    func checkInterfaceOrientation(interfaceOrientation: UIInterfaceOrientation) {

        switch interfaceOrientation {
        case .portrait, .portraitUpsideDown:
            if interfaceOrientation.isPortrait {
                labelForSwipe.text = "Swipe up to share"
            }
        case .landscapeLeft, .landscapeRight:
            if interfaceOrientation.isLandscape {
                labelForSwipe.text = "Swipe left to share"
            }
        default:
            break
        }
    }

    @objc func deviceOrientationChanged() {
        inspectDeviceOrientation()
    }

    func inspectDeviceOrientation() {
        let orientation = UIDevice.current.orientation
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            if orientation.isPortrait {
                labelForSwipe.text = "Swipe up to share"
            }
        case .landscapeRight, .landscapeLeft:
            if orientation.isLandscape {
                labelForSwipe.text = "Swipe left to share"
            }
        default:
            break
        }
    }
}



