//
//  ProfileTableViewController.swift
//  
//
//  Created by Arancha Ferrero Ortiz de Zárate on 19/11/16.
//
//

import UIKit
import Cosmos

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var userPhoto: UIImageView!
   
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMail: UILabel!
    @IBOutlet weak var userCourse: UILabel!
    @IBOutlet weak var userYearInCourse: UILabel!
    @IBOutlet weak var userRating: CosmosView!
    
    @IBAction func loggout(_ sender: Any) {
        Appdata.sharedInstance.mySubsList = []
        Appdata.sharedInstance.myUserID = ""
        UserDefaults.standard.set(nil, forKey: c.SAVED_USER_ID)
        //            self.present(LoginViewController(), animated: true, completion: nil)
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // **** Cosmos: rating star ****
        // **** Should be filled with user data ****
        
        // Change the cosmos view rating
        userRating.rating = 3
        
        // Change the text
        userRating.text = String(userRating.rating)
        
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        userRating.settings.updateOnTouch = false
        
        // Set round Profile Photo
        userPhoto.layer.borderWidth = 2.0
        userPhoto.layer.masksToBounds = false
        userPhoto.layer.borderColor = UIColor.white.cgColor
        userPhoto.layer.cornerRadius = 13
        userPhoto.layer.cornerRadius = userPhoto.frame.size.height/2
        userPhoto.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
