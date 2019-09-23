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

    // MARK: - @IBOutlets

    @IBOutlet weak var labelForSwipe: UILabel!
    @IBOutlet var changeLayoutButton: [UIButton]!
    @IBOutlet var gridViewButton: [UIButton]!
    @IBOutlet var gridView: PictureGridView!

    // MARK: - Properties
    var pictureGrid = PictureGrid()
    var images = [UIImage]()
    var imagePicked = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // selection layout 2 as default layout when application starts and applying the selected design to all buttons in the view
        startApplication(changeLayoutButton: changeLayoutButton)
        buttonDesignGridView()
        buttonDesignLayout()

        // observing device and interface orientation which will decide what some elements in the view should display
        let device = UIDevice.current
        device.beginGeneratingDeviceOrientationNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(deviceOrientationChanged),
                                       name: Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeMade(_:)))

        swipeUp.direction = .up
        swipeLeft.direction = .left

        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(swipeLeft)


    }

    // MARK: - @IBAction methods for swipe, layout buttons and grid view buttons

    //implementing two possible cases when the swipe is made, those vary through the interface and device orientation

    // TODO: - imageNotChosen is now broken even though i've limited the swipe to only work for up and left in their correct orientation
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait:
            if (sender.direction == .up) {
                imageNotChosen()
                animateSwipe(translationX: 0, y: -view.frame.height)
                activityViewController(sender)
            } else {
            print("unrecognized swipe direction")
            }
        default:
            if (sender.direction == .left) {
                imageNotChosen()
                animateSwipe(translationX: -view.frame.width, y: 0)
                activityViewController(sender)
            } else {
                print("unrecognized swipe direction")
            }
        }
    }

    // three possible cases when a change of layout is made each action hiding or showing button(s)
    @IBAction func buttonLayoutDidGetTapped(_ sender: UIButton) {
            animateButton(sender)

            switch sender.tag {
            case 0:
                // for the left button, concerning layout 1
                hidingButtonInPictureView(topRightButtonIsHidden: true, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                gridView.disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 0, isSelected: false)
            case 1:
                // for the middle button, concerning layout 2
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
                gridView.disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 1, isSelected: false)
            case 2:
                // for the right button, concerning layout 3
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: false)
                sender.isSelected = true
                sender.setImage(UIImage(named: "Selected"), for: .selected)
               gridView.disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 2, isSelected: false)
            default:
                break
            }
        }

    // action sheet for the UIImagePickerController, common to all buttons in grid view
    @IBAction func buttonTapped(_ sender: UIButton) {
        /* note: the specific action of displaying the alert through an action sheet has an effect of trigerring the console specific to iOS 12.2 and 12.3 as users online report not having this problem on previous iOS versions. The console error is reported as constraints which cannot be satisfied when the action sheet comes up into the screeen, the error being that the position, height and width of the action sheet are ambiguous in the UIView. This however seems to be a bug from Apple which still hasn't been fixed at the time of iOS 13.0 beta 7 as reported on the two StackOverFlow articles :
         https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
         https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
         */
        animateButton(sender)

        let myAlert = UIAlertController(title: "Select Image from", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in

                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                // makes it so that the user can only pick still images to share
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.imagePicked = sender.tag
                self.present(imagePicker, animated: true, completion: nil)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in

                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.imagePicked = sender.tag
                self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                myAlert.addAction(cameraAction)
    }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                myAlert.addAction(photoLibraryAction)
        }
        myAlert.addAction(cancelAction)
        self.present(myAlert, animated: true)
    }

    // pciking image and setting it to the button
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

    // MARK: - @obj methods

    @objc func deviceOrientationChanged() {
        let isPortrait = interfaceOrientationIsPortrait(interfaceOrientation: UIApplication.shared.statusBarOrientation)
        changeLabelBasedOnOrientation(isPortrait: isPortrait)
    }

    // MARK: - private methods

    // different interface orientation calls for different text to display on screen
   private func interfaceOrientationIsPortrait(interfaceOrientation: UIInterfaceOrientation) -> Bool {

        switch interfaceOrientation {
        case .portrait:
            return true
        default:
            return false
        }
    }

    private func changeLabelBasedOnOrientation(isPortrait: Bool) {
        if isPortrait {
            labelForSwipe.text = "Swipe up to share"
        } else {
            labelForSwipe.text = "Swipe left to share"
        }
    }

    // boolean parameters to hide buttons in grid view, used in with the layout buttons
   private func hidingButtonInPictureView(topRightButtonIsHidden: Bool, bottomRightButtonIsHidden: Bool) {
        gridViewButton[1].isHidden = topRightButtonIsHidden
        gridViewButton[3].isHidden = bottomRightButtonIsHidden
    }

    // starting application with the middle layout button selected and disabling the others
    private func startApplication(changeLayoutButton: [UIButton]) {
        for button in changeLayoutButton where button.tag == 1 {
                hidingButtonInPictureView(topRightButtonIsHidden: false, bottomRightButtonIsHidden: true)
                button.isSelected = true
                button.setImage(UIImage(named: "Selected"), for: .selected)
                gridView.disableLayoutButton(changeLayoutButton: changeLayoutButton, value: 1, isSelected: false)
        }
    }

    // swipe animation
    private func animateSwipe(translationX x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }

    // reseting view in layout through an animation and setting all buttons to their beginning images
    private func resetLayout(isError: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
                self.gridView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        if !isError {
            startApplication(changeLayoutButton: changeLayoutButton)
            for button in gridViewButton {
                button.setImage(UIImage(named: "Plus"), for: .normal)
                button.imageView?.contentMode = .scaleAspectFill
                button.clipsToBounds = true
            }
        }
    }

    // buttons animation for the layout and the grid view
    private func animateButton(_ sender: UIButton) {
        UIButton.animate(withDuration: 0.2, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)},
                         completion: { _ in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity})
        })
    }

    // rounding corners for buttons in grid view
    private func buttonDesignGridView() {
        for button in gridViewButton {
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
        }
    }

    //rounding corners for buttons in layout row
    private func buttonDesignLayout() {
        for button in changeLayoutButton {
            button.layer.cornerRadius = 3
            button.clipsToBounds = true
        }
    }

    // opening activity view controller after the swipe is made
    private func activityViewController(_ sender: UISwipeGestureRecognizer) {
        let image = pictureGrid.combineImage(gridView: gridView)
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.view.layoutIfNeeded()
        self.present(activityVC, animated: true, completion: nil)
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
            // on completion an alert is presented to the user confirming the image has been shared
            if completed {
                let message = "Your image has been shared"
                let alert = UIAlertController(title: "Great!", message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Awesome!",
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                                                self.resetLayout(isError: false)
                                                self.startApplication(changeLayoutButton: self.changeLayoutButton)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                // if the user quits before sharing, an error is presented
                let message = "Your image did not get shared, please try again"
                let error = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_: UIAlertAction!) in
                    self.resetLayout(isError: true)
                }))

                self.present(error, animated: true, completion: nil)
            }
        }
    }

    // checks if the user has filled all showing buttons wih different images than those use by default when the app starts
    private func imageNotChosen() {
        let image = UIImage(named: "Plus")
        for button in gridViewButton where (button.isHidden == false) && (button.currentImage == image) {
                let message = "You didn't choose images!"
                //displaying an error when the grid is not full
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Choose an image", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                    self.resetLayout(isError: true)
                }))
                self.present(alert, animated: true, completion: nil)
        }
    }
}
