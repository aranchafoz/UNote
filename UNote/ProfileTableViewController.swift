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
    
    // Cells Outlets
    @IBOutlet weak var cellName: UITableViewCell!
    @IBOutlet weak var cellPassword: UITableViewCell!
    @IBOutlet weak var cellCourse: UITableViewCell!
    @IBOutlet weak var cellYearInCourse: UITableViewCell!
    
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            //Do what you want to do.
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationUserNameTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (indexPath.section == 1 && indexPath.row == 2) {
            //Do what you want to do.
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationUserPasswordTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (indexPath.section == 2 && indexPath.row == 0) {
            //Do what you want to do.
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationUserCourseTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if (indexPath.section == 2 && indexPath.row == 1) {
            //Do what you want to do.
            let alert = UIAlertController(title: "Enter Input", message: "", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: configurationUserYearInCourseTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if(indexPath.section == 3 && indexPath.row == 0) {
            // Facebook connection account
        } else if (indexPath.section == 3 && indexPath.row == 1) {
            // Twitter connection account
        } else if (indexPath.section == 3 && indexPath.row == 2) {
            // Google Plus connection account
        }
    }

    func configurationUserNameTextField(textField: UITextField!)
    {
        
        textField.placeholder = "Enter your name"
        if textField.text != nil && textField.text != "" {
            userName.text = textField.text
        }
    }
    
    func configurationUserPasswordTextField(textField: UITextField!)
    {
        
        textField.placeholder = "Enter your new password"
    }
    
    func configurationUserCourseTextField(textField: UITextField!)
    {
        
        textField.placeholder = "Enter your course"
        if textField.text != nil && textField.text != "" {
            userCourse.text = textField.text
        }
    }
    
    func configurationUserYearInCourseTextField(textField: UITextField!)
    {
        
        textField.placeholder = "Enter your year in course"
        if textField.text != nil && textField.text != "" {
            userYearInCourse.text = textField.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
