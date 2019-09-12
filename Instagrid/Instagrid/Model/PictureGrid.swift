//
//  PictureGrid.swift
//  Instagrid
//
//  Created by Mark LEDOUX on 28/08/2019.
//  Copyright © 2019 Mark LEDOUX. All rights reserved.
//

import Foundation
import UIKit

struct PictureGrid {

    func combineImagesInPictureGridView(gridView: PictureGridView) -> UIImage {

        let render = UIGraphicsImageRenderer(size: gridView.frame.size)
        let image = render.image { ctx in
            gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
        return image
    }
}
