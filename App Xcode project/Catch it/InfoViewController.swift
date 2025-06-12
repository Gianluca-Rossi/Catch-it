//
//  InfoViewController.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 24/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import UIKit
import SceneKit

class InfoViewController: UIViewController {

    @IBOutlet weak var scenekitView: SCNView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var factsTextArea: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
