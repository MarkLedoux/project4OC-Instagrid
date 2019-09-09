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

        let upRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        upRecognizer.direction = .up
        self.view.addGestureRecognizer(upRecognizer)

        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view.addGestureRecognizer(leftRecognizer)


    }

    //MARK: - actions to share the images taken from the grid view using a swipe up when the device is in portrait and a left swipe when the device is in landscape
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {

        //TODO: - refactor the code to be able to remove the code written from lines 188 to 206 and make it possible for the selector in the notificationCenter to take swipeMade as its selector
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait, .portraitUpsideDown:
            if orientation.isPortrait {
                sender.direction = .up
                let myAlert = UIAlertController(title: "Swipe up detected", message: "Great you've made an upward swipe!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK!", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true)
            }
        case .landscapeLeft, .landscapeRight:
            if orientation.isLandscape {
                sender.direction = .left
                let myAlertForLandscape = UIAlertController(title: "Swipe left detected", message: "Great you've made a leftward swipe!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK!", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                } 
                    myAlertForLandscape.addAction(okAction)
                    self.present(myAlertForLandscape, animated: true)
            }
        default:
            break
        }
    }

    //MARK: - bottoms buttons actions
    //TODO: figure out how to place the Selected image according to the button without having to reference the spot and size specific CGRect

        @IBAction func buttonLayoutDidGetTapped(_ sender: UIButton) {
            UIButton.animate(withDuration: 0.2,animations: {
                sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                             completion: { finish in
                                UIButton.animate(withDuration: 0.2, animations: {
                                    sender.transform = CGAffineTransform.identity})
            })
            //necessary to specify the sender is a specific UiButton with a specific CGRect frame?
            let sender = sender
            sender.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            sender.isExclusiveTouch = true
            sender.setBackgroundImage(sender.currentImage, for: .normal)
            sender.setImage(UIImage(named: "Selected"), for: .selected)
            sender.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.addSubview(sender)
            dismiss(animated: true, completion: nil)

            switch sender.tag {
            case 0:
                // for the left button, concerning layout 1
                hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
                sender.isSelected = true

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 0, isSelected: false)
            case 1:
                // for the middle button, concerning layout 2
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                sender.isSelected = true

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 1, isSelected: false)
            case 2:
                // for the right button, concerning layout 3
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                
                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 2, isSelected: false)
            default:
                break
            }
        }

    //MARK: - methods to open the camera or the photo library
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
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
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
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        myAlert.addAction(cameraAction)
        myAlert.addAction(photoLibraryAction)
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString {
        if mediaType.isEqual(to: kUTTypeImage as String) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                buttonInPictureGridView[imagePicked].setImage(image, for: .normal)
                }
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

    //MARK: - methods to checks for device and for interface orientation when the app launches and when the app is running
   private func checkInterfaceOrientation(interfaceOrientation: UIInterfaceOrientation) {

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

    private func inspectDeviceOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
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

   private func hidingButtonInPictureView(topRightButtonIsHidden: Bool, bottomRightButtonIsHidden: Bool) {
        buttonInPictureGridView[1].isHidden = topRightButtonIsHidden
        buttonInPictureGridView[3].isHidden = bottomRightButtonIsHidden
    }

   private func disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: [UIButton], value: Int, isSelected: Bool) {
        for button in collectionOfButtonToChangeLayout {
            if button.tag != value {
                button.isSelected = isSelected
            }
        }
    }

}



