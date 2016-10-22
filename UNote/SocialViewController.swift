//
//  SocialViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserTableEditorCallBackProtocol {
    
    @IBAction func addFriendActionSheet(_ sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: "Add more friends", message: "How do you like to add them?", preferredStyle: .actionSheet)
        
        let Action1 = UIAlertAction(title: "From social", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            // Export from social
        })
        
        let Action2 = UIAlertAction(title: "From contacts", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            // Export from contacs (via number phone)
        })
        
        let Action3 = UIAlertAction(title: "Via nickname", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            // Search in our database
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(Action1)
        optionMenu.addAction(Action2)
        optionMenu.addAction(Action3)
        optionMenu.addAction(Cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var tbe_friend_table: UITableView!
    let friendsDemo : [String] = ["Peter","Alice","John","Kenneth","Anna","Julie","Matthew","Jake","Wilson","Sam","Paul"]
    var friends : NSMutableArray = []
    var selected_index = -1
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if friends.count == 0 {
        //            return friendsDemo.count
        //        }
        //        else {
        return friends.count
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        if friends.count == 0 {
            cell.textLabel?.text = friendsDemo[indexPath.row]
        }
        else {
            let friend:NSDictionary = friends[indexPath.row] as! NSDictionary
            let a = friend.object(forKey: c.TAG_USER_COURSE_LIST) as! Set<String>
            cell.textLabel?.text = friend.object(forKey: c.TAG_USER_NAME) as? String
            cell.detailTextLabel?.text? = "\(a) Year \(friend.object(forKey: c.TAG_JOIN_YR) as! Int)"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected_index = indexPath.row
        performSegue(withIdentifier: "segue_friend_profile", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_friend_profile" {
            log.d("HEYYY")
            
            let target:FriendProfileViewController = segue.destination as! FriendProfileViewController
            target.dict_info = friends[selected_index] as! NSDictionary
            
        }
        
    }
    
    func didGetItemSucceedWithItem(_ itemType:String, item:NSDictionary?){
        log.d("Get Succeed")
        //        log.d("\(item)")
        if itemType == c.TYPE_USER_INFO {
            
            if item != nil // Item found
            {
                log.d("hi")
                DispatchQueue.main.async {
                    self.friends.add(item)
                    self.tbe_friend_table.reloadData()
                }
            }
            
        }
    }
    
    
    func didSetItemWith(_ state:Bool, itemType:String){
        log.d("Set Succeed")
    }
    
    func didGetItemFailedWithError(_ itemType:String, error:String){
        log.d("Error Handling")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Appdata.sharedInstance.awsEditor?.scanAllUser()
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
