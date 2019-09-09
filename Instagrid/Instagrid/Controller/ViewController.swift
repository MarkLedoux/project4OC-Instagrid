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

    @IBOutlet weak var labelForSwipe: UILabel!
    @IBOutlet var collectionOfButtonToChangeLayout: [UIButton]!
    @IBOutlet var buttonInPictureGridView: [UIButton]!
    @IBOutlet var pictureView: PictureGridView!
    var imagePicked = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(deviceOrientationChanged), name: Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)

        checkInterfaceOrientation(interfaceOrientation: UIApplication.shared.statusBarOrientation)
    }

    //MARK: bottoms buttons actions
    //TODO: figure out how to place the Selected image according to the button without having to reference the spot and size specific CGRect

        @IBAction func buttonLayoutDidGetTapped(_ sender: UIButton) {
            UIButton.animate(withDuration: 0.2,animations: {
                sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity})
            })
            let sender = sender
            sender.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            //necessary to specify the sender is a specific UiButton with a specific CGRect frame?
            sender.isExclusiveTouch = true
            sender.setBackgroundImage(sender.currentImage, for: .normal)
            sender.setImage(UIImage(named: "Selected"), for: .selected)
            sender.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.addSubview(sender)
            dismiss(animated: true, completion: nil)

            switch sender.tag {
            case 1:
                // for the left button, concerning layout 1
                hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
                sender.isSelected = true

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 1, isSelected: false)
            case 2:
                // for the middle button, concerning layout 2
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                sender.isSelected = true

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 2, isSelected: false)
            case 3:
                // for the right button, concerning layout 3
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                
                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 3, isSelected: false)
            default:
                break
            }
        }

    //MARK: GridView buttons actions

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
                self.imagePicked = sender.tag
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cameraRollAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.imagePicked = sender.tag
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(cameraAction)
        myAlert.addAction(cameraRollAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                buttonInPictureGridView[imagePicked].setImage(image, for: .normal)
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

    func hidingButtonInPictureView(topRightButtonIsHidden: Bool, bottomRightButtonIsHidden: Bool) {
        buttonInPictureGridView[1].isHidden = topRightButtonIsHidden
        buttonInPictureGridView[3].isHidden = bottomRightButtonIsHidden
    }

    func disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: [UIButton], value: Int, isSelected: Bool) {
        for button in collectionOfButtonToChangeLayout {
            if button.tag != value {
                button.isSelected = isSelected
            }
        }
    }
}



