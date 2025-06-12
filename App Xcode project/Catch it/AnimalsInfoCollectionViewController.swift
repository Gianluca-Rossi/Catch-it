//
//  AnimalsInfoCollectionViewController.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 24/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell"

class AnimalsInfoCollectionViewController: UICollectionViewController {

    var animalList = [AnimalInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adds elements to the list
        self.animalList = [
            AnimalInfo(name: "bear", facts: ["1. American black bears are found in Canada, Mexico and North America.",
                                             "2. They mostly eat grasses, herbs and fruit, but will sometimes eat other things, including fish.",
                                             "3. The black bear’s coat has lots of layers of shaggy fur, which keeps it warm in cold winter months.",
                                             "4. They may be called black bears, but their coat can be blue-gray or blue-black, brown and even sometimes white!",
                                             "5. Their short claws make black bears expert tree climbers.",
                                             "6. They may be large, but black bears can run up to 40kmph!",
                                             "7. These big bears have a very good sense of smell and can often be seen standing on their hind legs, sniffing scents!",
                                             "8. They usually live in forests but black bears are also found in mountains and swamps.",
                                             "9. Black bears spend winter dormant in their dens, feeding on body fat they have built up over the summer and autumn.",
                                             "10. They make their dens in caves, burrows or other sheltered spots. Sometimes they even make them in tree holes high above the ground!"])
        ]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return animalList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AnimalsInfoCollectionViewCell
    
        // Configure the cell
        cell.nameLabel.text = self.animalList[indexPath.row].name
        cell.infoTextfield.text = self.animalList[indexPath.row].facts.first
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showInfo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showInfo") {
            
            let indexPath = collectionView.indexPathsForSelectedItems![0] as NSIndexPath
            
            let infoVC = segue.destination as! InfoViewController
            
            
            infoVC.nameLabel.text = self.animalList[indexPath.row].name
            
            var factsCombined = ""
            
            for fact in self.animalList[indexPath.row].facts {
                factsCombined.append("\n\(fact)")
            }
            
            infoVC.factsTextArea.text = factsCombined
            
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
