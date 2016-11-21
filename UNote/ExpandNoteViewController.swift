//
//  ExpandNoteViewController.swift
//  UNote
//
//  Created by Arancha Ferrero Ortiz de Zárate on 21/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class ExpandNoteViewController: UIViewController {
    
    @IBOutlet weak var expandImage: UIImageView!
    
    var toPass:UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expandImage.image = toPass
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
