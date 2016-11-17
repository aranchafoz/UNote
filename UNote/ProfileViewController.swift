//
//  ProfileViewController.swift
//  UNote
//
//  Created by Arancha Ferrero Ortiz de Zárate on 17/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit
import Cosmos

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundUser: UIImageView!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userCourse: UILabel!
    @IBOutlet weak var userMajorYear: UILabel!
    @IBOutlet var userRatingStars: CosmosView!
    
    //
    // Cosmos: rating
    //
    
    
    @IBAction func loggout(_ sender: Any) {
        
        Appdata.sharedInstance.mySubsList = []
        Appdata.sharedInstance.myUserID = ""
        UserDefaults.standard.set(nil, forKey: c.SAVED_USER_ID)
        //            self.present(LoginViewController(), animated: true, completion: nil)
        exit(0)
        // why dont just close the app?? B)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Change the cosmos view rating
        userRatingStars.rating = 3
        
        // Change the text
        userRatingStars.text = String(userRatingStars.rating)
        
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        userRatingStars.settings.updateOnTouch = false
        

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
