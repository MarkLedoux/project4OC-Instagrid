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
    @IBOutlet var gridView: PictureGridView!

    var pictureGrid = PictureGrid()
    var images = [UIImage]()
    var imagePicked = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        startApplication(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout)

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

        let orientation = UIDevice.current.orientation
        let image = pictureGrid.combineImagesInPictureGridView(gridView: gridView)
            switch orientation {
        case .portrait, .portraitUpsideDown:
            if orientation.isPortrait {
                sender.direction = .up
                animateSwipe(translationX: 0, y: -view.frame.height)

                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.view.layoutIfNeeded()
                self.present(activityViewController, animated: true, completion: nil)
            }
        case .landscapeLeft, .landscapeRight:
            if orientation.isLandscape {
                sender.direction = .left
                animateSwipe(translationX: -view.frame.width, y: 0)

                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)

                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.view.layoutIfNeeded()
                self.present(activityViewController, animated: true, completion: nil)
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
            //necessary to specify the sender is a specific UiButton with a specific CGRect frame

            switch sender.tag {
            case 0:
                // for the left button, concerning layout 1
                hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 0, isSelected: false)
            case 1:
                // for the middle button, concerning layout 2
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)

                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 1, isSelected: false)
            case 2:
                // for the right button, concerning layout 3
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                
                disableButtonWhenGivenValueIsDifferent(collectionOfButtonToChangeLayout: collectionOfButtonToChangeLayout, value: 2, isSelected: false)
            default:
                break
            }
        }

    //MARK: - methods to open the camera or the photo library
    @IBAction func buttonTapped(_ sender: UIButton) {
        /* note: the specific action of displaying the alert through an action sheet has an effect of trigerring the console specific to iOS 12.2 and 12.3 as users online report not having this problem on previous iOS versions. The console error is reported as constraints which cannot be satisfied when the action sheet comes up into the screeen, the error being that the position, height and width of the action sheet are ambiguous in the UIView. This however seems to be a bug from Apple which still hasn't been fixed at the time of iOS 13.0 beta 7 as reported on the two StackOverFlow articles :
         https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
         https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
         */

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
                buttonInPictureGridView[imagePicked].imageView?.contentMode = .scaleAspectFill
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

    private func startApplication(collectionOfButtonToChangeLayout: [UIButton]) {
        for button in collectionOfButtonToChangeLayout {
            if button.tag == 1 {
                buttonInPictureGridView[3].isHidden = true
                button.isSelected = true
                button.setImage(UIImage(named: "Selected"), for: .selected)
            }
        }

    }

    private func animateSwipe(translationX x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
}



