//
//  FriendProfileViewController.swift
//  UNote
//
//  Created by David Ivorra on 20/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UserTableEditorCallBackProtocol{

    @IBOutlet weak var profileBackground: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    // Options Action Sheet
    @IBAction func optionsActionSheet(_ sender: AnyObject) {
        let optionMenu = UIAlertController()
        
        var Action1:UIAlertAction
        if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {
            Action1 = UIAlertAction(title: "Unfollow", style: .default, handler: {(alert: UIAlertAction!) -> Void in
                // Unfollow this friend
            })
        } else {
            Action1 = UIAlertAction(title: "follow", style: .default, handler: {(alert: UIAlertAction!) -> Void in
                let tempFriends:NSMutableArray = Appdata.sharedInstance.mySubsList
                tempFriends.add(self.dict_info?.object(forKey: c.TAG_USER_ID) as! String)
                Appdata.sharedInstance.awsEditor?.setSubscribleList(tempFriends)
            })
        }
        
        
        
        let Action2 = UIAlertAction(title: "Send an email", style: .default, handler: {(alert: UIAlertAction!) -> Void in
        // Send an email to this friend
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(Action1)
        optionMenu.addAction(Action2)
        optionMenu.addAction(Cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }

    @IBOutlet weak var lbl_major: UILabel!
    @IBOutlet weak var lbl_year: UILabel!
    
    // data source
    let files:NSMutableArray = []
    var friend_file_list:NSMutableArray = []
    var list_ready = false
    var dict_info:NSDictionary?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as UICollectionViewCell
        
        let dict_file:NSDictionary = files[indexPath.row] as! NSDictionary
        log.d("index: \(indexPath.row)")
        // Set Subject name
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.1
        value.text = dict_file.object(forKey: c.TAG_FILE_NAME) as! String
        
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
        return folderCell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dict_info == nil {
            log.d("ERROR")
        } else {
            log.d(dict_info?.object(forKey: c.TAG_USER_NAME) as! String)
            navigationItem.title = dict_info?.object(forKey: c.TAG_USER_NAME) as! String
        }
        list_ready = false
        files.removeAllObjects()
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
                for var i in 0..<friend_file_list.count {
                    Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(friend_file_list[i] as! String)
                }
            }
        }
            
        else if itemType == c.TYPE_FILE {
            
            if item != nil // Item found
            {
                files.add(item)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            
        }
    }
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
    }
    func didSetItemWith(_ state: Bool, itemType: String) {  // add/remove friend succeed
        if state && itemType == c.TYPE_USER_SUBS {
            if Appdata.sharedInstance.mySubsList.contains(dict_info?.object(forKey: c.TAG_USER_ID) as! String) {    // target exist, remove it
                let target = dict_info?.object(forKey: c.TAG_USER_ID) as! String
                for var i in 0..<Appdata.sharedInstance.mySubsList.count {
                    if Appdata.sharedInstance.mySubsList[i] as! String == target {
                        Appdata.sharedInstance.mySubsList.removeObject(at: i)
                    }
                }
            } else {    // inexist, add friend
                Appdata.sharedInstance.mySubsList.add(dict_info?.object(forKey: c.TAG_USER_ID) as! String)
            }
            
        }
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
        //        Appdata.sharedInstance.awsEditor?.delegate = nil
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
