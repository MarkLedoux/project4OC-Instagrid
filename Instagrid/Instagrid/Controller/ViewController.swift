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
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.deviceOrientationForSwipeToShare(deviceOrientation:)), name: UIDevice.orientationDidChangeNotification, object: nil)

    }

    //MARK: bottoms buttons actions
    //TODO: figure out how to place the Selected image according to the button without having to reference the spot and size specific CGRect
    @IBOutlet weak var labelForSwipe: UILabel!

    @IBOutlet var collectionOfButtonToChangeLayout: [UIButton]!
    @IBOutlet var pictureView: PictureGridView!

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
        pictureView.buttonInPictureGridView[0].isHidden = true
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



