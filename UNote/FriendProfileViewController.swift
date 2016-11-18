//
//  FriendProfileViewController.swift
//  UNote
//
//  Created by David Ivorra on 20/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit
import Cosmos
import MessageUI


extension UIViewController {
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

class FriendProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UserTableEditorCallBackProtocol, MFMailComposeViewControllerDelegate{

    @IBOutlet weak var profileBackground: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var txt_major: UILabel!
    @IBOutlet weak var txt_yr: UILabel!
    @IBOutlet weak var btn_follow: UIButton!
    
    @IBOutlet weak var friendRatingPoints: UILabel!
    @IBOutlet weak var friendRatingStar: CosmosView!
    
    
    // Options Action Sheet
    @IBAction func optionsActionSheet(_ sender: AnyObject) {
        let optionMenu = UIAlertController()
        
        var Action1:UIAlertAction
        if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
            Action1 = UIAlertAction(title: "Unfollow", style: .default, handler: {(alert: UIAlertAction!) -> Void in
                // Unfollow this friend
                let tempFriends:NSMutableArray = NSMutableArray(array:Array(Appdata.sharedInstance.mySubsList))
                for var i in 0..<Appdata.sharedInstance.mySubsList.count {
                    if (tempFriends[i] as! String) == (self.dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
                        tempFriends.removeObject(at: i)
                        Appdata.sharedInstance.awsEditor?.setSubscribleList(tempFriends)
                        break;
                    }
                }
            })
        } else {
            Action1 = UIAlertAction(title: "follow", style: .default, handler: {(alert: UIAlertAction!) -> Void in
                let tempFriends:NSMutableArray = NSMutableArray(array:Array(Appdata.sharedInstance.mySubsList))
                tempFriends.add(self.dict_info?.object(forKey: c.TAG_USER_ID) as! String)
                Appdata.sharedInstance.awsEditor?.setSubscribleList(tempFriends)
            })
        }
        
        
        
        let Action2 = UIAlertAction(title: "Send an email", style: .default, handler: {(alert: UIAlertAction!) -> Void in
        // Send an email to this friend
            
            
           self.sendEmailInvoker()
            
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        
        
        optionMenu.addAction(Action1)
        optionMenu.addAction(Action2)
        optionMenu.addAction(Cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

    @IBOutlet weak var lbl_major: UILabel!
    @IBOutlet weak var lbl_year: UILabel!
    
    // data source
    let files:NSMutableArray = []
    var files_dict = [NSDictionary]()
    var friend_file_list:NSMutableArray = []
    var list_ready = false
    var dict_info:NSDictionary?
    var subjectList = [String]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    func sendEmailInvoker(){
        
        let mailComposeviewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail(){
            
         self.present(mailComposeviewController, animated: true, completion: nil)
            
            
        }else{
            
            self.showSendMailErrorAlert()
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController{
        
        let mailComposerVC = MFMailComposeViewController()
        
        mailComposerVC.mailComposeDelegate = self
        
        var user_profile_id = dict_info?.object(forKey: c.TAG_USER_ID) as! String
        
        if user_profile_id.contains("@") {
        
            
            mailComposerVC.setToRecipients([user_profile_id])
            mailComposerVC.setSubject("send test mail")
            mailComposerVC.setMessageBody("hi", isHTML: false)
            
            
        }else{
            
            self.alert(message: "This user have no provide e-mail")
            
        }
        
        return mailComposerVC
        
    }
    
    
    func showSendMailErrorAlert(){
        
        
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Please check email configuration and try again", preferredStyle: .alert)
        
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return files.count
    
        return subjectList.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let folder_course_name = subjectList[indexPath.row]
        
        var relatedCourseMaterial = [NSDictionary]()
        
        
        for file in files_dict{
        
            let fileCourse = file.object(forKey: c.TAG_FILE_COURSE) as! String
            if fileCourse == folder_course_name {
                
                relatedCourseMaterial.append(file)
                
                
                print("========")
                print(file.object(forKey: c.TAG_USER_ID))
                print(file.object(forKey: c.TAG_USER_NAME))
                
                
            }
        }
        
        UserDefaults.standard.setValue(relatedCourseMaterial, forKey: "savedMaterial")
        
        UserDefaults.standard.setValue(folder_course_name, forKey: "course")
        
        UserDefaults.standard.setValue(navigationItem.title, forKey: "userID")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as UICollectionViewCell
        
        
        
        let course_folder_name = subjectList[indexPath.row]
        
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.1
        value.text = course_folder_name
        
        let img = folderCell.contentView.viewWithTag(1) as! UIImageView
        img.image = UIImage(named: "Folder")
        
        
        /*
        
        let dict_file:NSDictionary = files[indexPath.row] as! NSDictionary
        log.d("index: \(indexPath.row)")
        // Set Subject name
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.1
        value.text = dict_file.object(forKey: c.TAG_FILE_NAME) as! String
        */
        
        
        /*
        
        // Set File image
        let img = folderCell.contentView.viewWithTag(1) as! UIImageView
        if (value.text?.contains(".pdf"))! {
            img.image = UIImage(named: "file_pdf")
        }
        else if (value.text?.contains(".doc"))! {
            img.image = UIImage(named: "file_doc")
        }
        else if (value.text?.contains(".png"))! || (value.text?.contains(".jpg"))!{
            img.image = UIImage(named: "file_img")
        }
        else {
            img.image = UIImage(named: "file_unknown")
        }
 
        */
        
        
        
        return folderCell
    }
    
    @IBAction func pressed_follow(_ sender: AnyObject) {
        
        if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
            // Unfollow this friend
            let tempFriends:NSMutableArray = NSMutableArray(array:Array(Appdata.sharedInstance.mySubsList))
            for var i in 0..<Appdata.sharedInstance.mySubsList.count {
                if (tempFriends[i] as! String) == (self.dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
                    tempFriends.removeObject(at: i)
                    Appdata.sharedInstance.awsEditor?.setSubscribleList(tempFriends)
                    break;
                }
            }
        }
        else {
            let tempFriends:NSMutableArray = NSMutableArray(array:Array(Appdata.sharedInstance.mySubsList))
            tempFriends.add(self.dict_info?.object(forKey: c.TAG_USER_ID) as! String)
            Appdata.sharedInstance.awsEditor?.setSubscribleList(tempFriends)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // **** Cosmos: rating star **** 
        // **** Should be filled with user data ****
        
        // Change the cosmos view rating
        friendRatingStar.rating = 3
        
        // Change the text
        friendRatingPoints.text = String(friendRatingStar.rating)
        
        // Called when user finishes changing the rating by lifting the finger from the view.
        // This may be a good place to save the rating in the database or send to the server.
        friendRatingStar.didFinishTouchingCosmos = { rating in }
        
        // A closure that is called when user changes the rating by touching the view.
        // This can be used to update UI as the rating is being changed by moving a finger.
        friendRatingStar.didTouchCosmos = { rating in
            self.friendRatingPoints.text = String(self.friendRatingStar.rating)}
        

        
        
        if dict_info == nil {
            log.d("ERROR")
        } else {
            log.d(dict_info?.object(forKey: c.TAG_USER_NAME) as! String)
            navigationItem.title = dict_info?.object(forKey: c.TAG_USER_NAME) as! String
            txt_major.text = Array(dict_info?.object(forKey: c.TAG_USER_COURSE_LIST) as! Set<String>).first
            let yr = dict_info?.object(forKey: c.TAG_JOIN_YR) as! Int
            if yr==1 {
                txt_yr.text = "\(yr)st"
            } else if yr==2 {
                txt_yr.text = "\(yr)nd"
            } else if yr==3 {
                txt_yr.text = "\(yr)rd"
            } else {
                txt_yr.text = "\(yr)th"
            }
            if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
                btn_follow.setBackgroundImage(UIImage(named:"tick_blue"), for: .normal)
            } else {
                btn_follow.setBackgroundImage(UIImage(named:"add_green"), for: .normal)
            }
        }
        list_ready = false
        files.removeAllObjects()
        files_dict.removeAll()
        collectionView.reloadData()
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(dict_info?.object(forKey: c.TAG_USER_ID) as! String)
        
        
        // Do any additional setup after loading the view.
        profilePicture.layer.borderWidth = 2.0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.cornerRadius = 13
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.clipsToBounds = true
        
    }
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        if itemType == c.TYPE_USER_FILE {
            if item != nil {
                list_ready = true
                friend_file_list = NSMutableArray(array:Array(item?.object(forKey: c.TAG_FILE_LIST) as! Set<String>))
                files.removeAllObjects()
                files_dict.removeAll()
                for var i in 0..<friend_file_list.count {
                    Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(friend_file_list[i] as! String)
                }
            }
        }
            
        else if itemType == c.TYPE_FILE {
            
            if item != nil // Item found
            {
                let subjectName = item?.object(forKey: c.TAG_FILE_COURSE) as! String
                files.add(item)
                files_dict.append(item!)
                
                if subjectList.contains(subjectName) == false {
                    
                    print("======")
                    print(subjectName)
                    subjectList.append(subjectName)
                    
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
    }
    func didSetItemWith(_ state: Bool, itemType: String) {  // add/remove friend succeed
        log.d("01:\n\(Appdata.sharedInstance.mySubsList)")
        if state && itemType == c.TYPE_USER_SUBS {
            if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {    // target exist, remove it
                log.d("YOOOOOO")
                let target = dict_info?.object(forKey: c.TAG_USER_ID) as! String
                for var i in 0..<Appdata.sharedInstance.mySubsList.count {
                    if Appdata.sharedInstance.mySubsList[i] as! String == target {
                        Appdata.sharedInstance.mySubsList.removeObject(at: i)
                    }
                }
            } else {    // inexist, add friend
                log.d("HEYYYYY")
                Appdata.sharedInstance.mySubsList.add(dict_info?.object(forKey: c.TAG_USER_ID) as! String)
            }
            
            DispatchQueue.main.async {
                if Appdata.sharedInstance.mySubsList.contains(self.dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
                    self.btn_follow.setBackgroundImage(UIImage(named:"tick_blue"), for: .normal)
                } else {
                    self.btn_follow.setBackgroundImage(UIImage(named:"add_green"), for: .normal)
                }
            }
            
        }
        log.d("02\n\(Appdata.sharedInstance.mySubsList)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss delegate
               Appdata.sharedInstance.awsEditor?.delegate = nil
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
