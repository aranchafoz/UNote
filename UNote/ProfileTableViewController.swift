//
//  ProfileTableViewController.swift
//  
//
//  Created by Arancha Ferrero Ortiz de Zárate on 19/11/16.
//
//

import UIKit
import Cosmos

class ProfileTableViewController: UITableViewController , UserTableEditorCallBackProtocol{

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
    
    @IBOutlet weak var emailCell: UITableViewCell!
    // Cells Outlets
    @IBOutlet weak var cellName: UITableViewCell!
    @IBOutlet weak var cellPassword: UITableViewCell!
    @IBOutlet weak var cellCourse: UITableViewCell!
    @IBOutlet weak var cellYearInCourse: UITableViewCell!
     var userProfileDict:NSDictionary!
    
    
    
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
    }
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        
        
        if itemType == c.TYPE_USER_INFO {
            
            
            if item != nil {
                
                
                userProfileDict = item
                
                print("=====")
                
                print(userProfileDict)
                
                
                setProfileInformation()
                
                
                
            }else{
                
                
            }
            
            
        }else{
            
            
            
        }
        
    }
    
    
    func setProfileInformation(){
        
        
        
        let name = userProfileDict.object(forKey:c.TAG_USER_NAME)
        
        
        if name != nil {
            
            let nameLabel = cellName.contentView.viewWithTag(1) as! UILabel
            
            nameLabel.text = name as? String
            
            
            cellName.reloadInputViews()
            
        }
        
        
        let userID = userProfileDict.object(forKey: c.TAG_USER_ID) as! String
        
        
        if userID.contains("@") {
            
            
            
            let userIDLabel = emailCell.contentView.viewWithTag(1) as! UILabel
            
            userIDLabel.text = userID
            emailCell.reloadInputViews()
            
        }else if !userID.contains("@"){
            
            let userIDLabel = emailCell.contentView.viewWithTag(1) as! UILabel
            
            userIDLabel.text = "Not provided"
            
            
            emailCell.reloadInputViews()
            
            
            
            
        }
        
        let yearJoin = userProfileDict.object(forKey: c.TAG_JOIN_YR) as! Int
        
        
        
        
        if yearJoin != 0 {
            
            
            let yearLabel = cellYearInCourse.contentView.viewWithTag(1) as! UILabel
            
            
            yearLabel.text = String(yearJoin)
            
            
            cellYearInCourse.reloadInputViews()
            
        }else{
        
            let yearLabel = cellYearInCourse.contentView.viewWithTag(1) as! UILabel
            
            
            yearLabel.text = "Not provided"
            
          
            cellYearInCourse.reloadInputViews()
        
        }
        
        
        
        
        
        
        
        let userCourse = userProfileDict.object(forKey: c.TAG_USER_COURSE_LIST)
        
        print(userCourse)
        
        print("Type of")
        print(type(of: userCourse))
        
        if userCourse != nil{
            
            let courseLabel = cellCourse.contentView.viewWithTag(1) as! UILabel
            
            
            //courseLabel.text = userCourse as! String
            
            
            let course = userCourse as! Set<String>
            
            print("++++++")
            print(course)
            
            let courseArr = [String](course)
            courseLabel.text = courseArr[0]
            
        
            
            
            cellCourse.reloadInputViews()
            
            
            
            
        }else{
            
            print("Error")
        }
        
        
        
        
    }
    
    
    func didSetItemWith(_ state: Bool, itemType: String) {
     
        
        print("&&&&&&&&&")
        print(state)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        Appdata.sharedInstance.awsEditor?.delegate = self
        
        Appdata.sharedInstance.awsEditor?.getUserInfoById((Appdata.sharedInstance.awsEditor?.getUserIdentity())!)
        
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Appdata.sharedInstance.awsEditor?.delegate = nil
        
        
        
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
        
        
        print("ffffffff")
        textField.placeholder = "Enter your name"
        if textField.text != nil && textField.text != "" {
            userName.text = textField.text
            
        
            
            
            let original_courseList = self.userProfileDict.object(forKey: c.TAG_USER_COURSE_LIST)
            let timeStamp = c.getTimestamp()
            let jointYr = self.userProfileDict.object(forKey: c.TAG_JOIN_YR) as! Int
            let newName = textField.text
            
            Appdata.sharedInstance.awsEditor?.setUserInfo(original_courseList as! Set<String>?, joinTimestamp: timeStamp, joinYr: jointYr, name: newName, selfIntro: nil)
            
            print("ooooooo")
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
            
            
            let original_courseList = self.userProfileDict.object(forKey: c.TAG_USER_COURSE_LIST)
            var courseListArr = [String](original_courseList as! Set<String>)
            courseListArr[0] = textField.text!
            let editCourse = Set<String>(courseListArr)
            let timeStamp = c.getTimestamp()
            let jointYr = self.userProfileDict.object(forKey: c.TAG_JOIN_YR) as! Int
            let old_name = self.userProfileDict.object(forKey: c.TAG_USER_NAME)
            
            Appdata.sharedInstance.awsEditor?.setUserInfo(editCourse , joinTimestamp: timeStamp, joinYr: jointYr, name: old_name as! String?, selfIntro: nil)
            
            
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
