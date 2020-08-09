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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func objectSelectButton(_ sender: UIButton) {
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
