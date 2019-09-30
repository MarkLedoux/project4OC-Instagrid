//
//  PictureGridView.swift
//  Instagrid
//
//  Created by Mark LEDOUX on 05/09/2019.
//  Copyright © 2019 Mark LEDOUX. All rights reserved.
//

import UIKit

class PictureGridView: UIView {
    @IBOutlet var buttonInPictureGridView: [UIButton]!

    // disabling button aside from the selected button
    func disableLayoutButton(changeLayoutButton: [UIButton], value: Int, isSelected: Bool) {
        for button in changeLayoutButton where button.tag != value {
            button.isSelected = isSelected
        }
    }

    func combineImage(gridView: PictureGridView) -> UIImage {

        let render = UIGraphicsImageRenderer(size: gridView.frame.size)
        let image = render.image { _ in
            gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
