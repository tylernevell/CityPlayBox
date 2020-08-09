//
//  MenuViewController.swift
//  ARDicee
//
//  Created by Tyler Nevell on 8/9/20.
//  Copyright © 2020 Tyler Nevell. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var selectedObjectString: String?
    //var denizSpecialSurprise: String?
    
//    var objectsBrain = ObjectsBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func objectSelectButton(_ sender: UIButton) {
        
        
        selectedObjectString = sender.currentTitle
        print(sender.currentTitle!)
//        if let userChoice = sender.currentTitle {
//            // grab the scene object's file name to put into the scene
//            selectedObjectString = objectsBrain.get_objectFileName(choice: userChoice)
//            // barely awake and struggling to put into words what exactly this string is for
//            denizSpecialSurprise = objectsBrain.get_theName(choice: userChoice)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToMenu" {
            let destinationVC = segue.destination as! MenuViewController
            // if the string being passed back from MenuVC
            destinationVC.selectedObjectString = selectedObjectString
                
            print(destinationVC.selectedObjectString!)
            
            
        }
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
