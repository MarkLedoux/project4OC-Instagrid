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
    @IBOutlet var changeLayoutButton: [UIButton]!
    @IBOutlet var gridViewButton: [UIButton]!
    @IBOutlet var gridView: PictureGridView!

    var pictureGrid = PictureGrid()
    var images = [UIImage]()
    var imagePicked = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        startApplication(changeLayoutButton: changeLayoutButton)

        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(deviceOrientationChanged),
                                       name: Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)

        checkInterfaceOrientation(interfaceOrientation: UIApplication.shared.statusBarOrientation)

        let upRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        upRecognizer.direction = .up
        self.view.addGestureRecognizer(upRecognizer)

        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        self.view.addGestureRecognizer(leftRecognizer)
    }

    // MARK: - animate the view after detecting swipe direction
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        imageNotChosen(sender)
        let orientation = UIDevice.current.orientation
            switch orientation {
            case .portrait, .portraitUpsideDown:
            if orientation.isPortrait {
                sender.direction = .up
                animateSwipe(translationX: 0, y: -view.frame.height)
                activityViewController(sender)
            }
            case .landscapeLeft, .landscapeRight:
            if orientation.isLandscape {
                sender.direction = .left
                animateSwipe(translationX: -view.frame.width, y: 0)
                activityViewController(sender)
                }
            default:
            break
        }
    }

    // MARK: - bottoms buttons actions

        @IBAction func buttonLayoutDidGetTapped(_ sender: UIButton) {
            animateButton(sender)

            switch sender.tag {
            case 0:
                // for the left button, concerning layout 1
                hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 0, isSelected: false)
            case 1:
                // for the middle button, concerning layout 2
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 1, isSelected: false)
            case 2:
                // for the right button, concerning layout 3
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 2, isSelected: false)
            default:
                break
            }
        }

    // MARK: - methods to open the camera or the photo library
    @IBAction func buttonTapped(_ sender: UIButton) {
        // swiftlint:disable:next line_length
        /* note: the specific action of displaying the alert through an action sheet has an effect of trigerring the console specific to iOS 12.2 and 12.3 as users online report not having this problem on previous iOS versions. The console error is reported as constraints which cannot be satisfied when the action sheet comes up into the screeen, the error being that the position, height and width of the action sheet are ambiguous in the UIView. This however seems to be a bug from Apple which still hasn't been fixed at the time of iOS 13.0 beta 7 as reported on the two StackOverFlow articles :
         https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
         https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
         */
        animateButton(sender)

        let myAlert = UIAlertController(title: "Select Image from", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
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
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
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
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
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
                gridViewButton[imagePicked].setImage(image, for: .normal)
                gridViewButton[imagePicked].imageView?.contentMode = .scaleAspectFill
                gridViewButton[imagePicked].clipsToBounds = true
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            let message = "Failed to save image"
            let alert = UIAlertController(title: "Save failed", message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - private methods only used in the file itself
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
        gridViewButton[1].isHidden = topRightButtonIsHidden
        gridViewButton[3].isHidden = bottomRightButtonIsHidden
    }

   private func disableLayoutButton(changeLayoutButton: [UIButton], value: Int, isSelected: Bool) {
    for button in changeLayoutButton where button.tag != value {
                button.isSelected = isSelected
        }
    }

    private func startApplication(changeLayoutButton: [UIButton]) {
        for button in changeLayoutButton where button.tag == 1 {
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                button.isSelected = true
                button.setImage(UIImage(named: "Selected"), for: .selected)
                disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 1, isSelected: false)
        }
    }

    // swiftlint:disable:next identifier_name
    private func animateSwipe(translationX x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }

    private func resetLayout(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        startApplication(changeLayoutButton: changeLayoutButton)
        for button in gridViewButton {
            button.setImage(UIImage(named: "Plus"), for: .normal)
            button.imageView?.contentMode = .scaleAspectFill
            button.clipsToBounds = true
        }
    }

    private func animateButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                         completion: { _ in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity})
        })
    }

    private func activityViewController(_ sender: UISwipeGestureRecognizer) {
        let image = pictureGrid.combineImagesInPictureGridView(gridView: gridView)
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.view.layoutIfNeeded()
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            if completed {
                let message = "Your image has been shared"
                let alert = UIAlertController(title: "Great!", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Awesome!",
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                                                self.resetLayout(sender)
                                                self.startApplication(changeLayoutButton: self.changeLayoutButton)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                let message = "Something wrong happened, please try again"
                let error = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    self.resetLayout(sender)
                }))

                self.present(error, animated: true, completion: nil)
            }
        }
    }

    private func imageNotChosen(_ sender: UISwipeGestureRecognizer) {
        let image = UIImage(named: "Plus")
        for button in gridViewButton where button.isHidden == false && button.currentImage == image {
                    let message = "You didn't choose images!"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Choose an image",
                                                  style: UIAlertAction.Style.default,
                                                  handler: {(_: UIAlertAction!) in
                                                    self.resetLayout(sender)
                    }))
                    self.present(alert, animated: true, completion: nil)
        }
    }
}
