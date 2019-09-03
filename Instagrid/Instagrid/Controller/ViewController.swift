//
//  ViewController.swift
//  Instagrid
//
//  Created by Mark LEDOUX on 20/08/2019.
//  Copyright © 2019 Mark LEDOUX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var image = UIImage(named: "Selected")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: bottoms buttons actions
    @IBOutlet weak var topRightButton: UIButton!
    @IBOutlet weak var bottomRightButton: UIButton!
    @IBOutlet weak var topLeftButton: UIButton!
    @IBOutlet weak var bottomLeftButton: UIButton!
    @IBOutlet weak var firstLayoutSelected: UIButton!
    @IBOutlet weak var secondLayoutSelected: UIButton!
    @IBOutlet weak var thirdLayoutSelected: UIButton!

    @IBAction func firstLayout(_ sender: Any) {
        topRightButton.isHidden = true
        bottomRightButton.isHidden = false
        firstLayoutSelected.setImage(image, for: .highlighted)

    }
    @IBAction func secondLayout(_ sender: Any) {
        topRightButton.isHidden = false
        bottomRightButton.isHidden = true
        secondLayoutSelected.setImage(image, for: .highlighted)

    }
    @IBAction func thirdLayout(_ sender: Any) {
        topRightButton.isHidden = false
        bottomRightButton.isHidden = false
        thirdLayoutSelected.setImage(image, for: .highlighted)
        
    }

    //MARK: GridView buttons actions

    

}



