//
//  AnimalsInfoCollectionViewCell.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 24/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import UIKit
import SceneKit

class AnimalsInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var sceneKitView: SCNView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoTextfield: UITextView!
    
}
