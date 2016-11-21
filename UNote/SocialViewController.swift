//
//  SocialViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UserTableEditorCallBackProtocol {
    
    var txtDialog:UITextField!
    let v_refresh:UIRefreshControl = UIRefreshControl()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func addFriendActionSheet(_ sender: AnyObject) {
        
        let optionMenu = UIAlertController(title: "Add more friends", message: "How do you like to add them?", preferredStyle: .actionSheet)
        
        let Action1 = UIAlertAction(title: "From Email", style: .default, handler: {(alert: UIAlertAction!) -> Void in

        })
        
        let Action2 = UIAlertAction(title: "From contacts", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            // Export from contacs (via number phone)
        })
        
        let cheat = UIAlertAction(title: "-Demo- Show all users", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            self.friends.removeAllObjects()
            Appdata.sharedInstance.awsEditor?.scanAllUser()
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in

        })
        
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        optionMenu.addAction(Action1)
        optionMenu.addAction(Action2)
        optionMenu.addAction(cheat)
        optionMenu.addAction(Cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    @IBAction func search(_ sender: AnyObject) {
        log.d("HIIIIIII")
        let alert = UIAlertController(title: "Browse", message: "Please Enter Email", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
            if self.txtDialog.text! != "" {
                self.your_have_no_friend_identifier = false
                self.friends.removeAllObjects()
                self.tbe_friend_table.reloadData()
                Appdata.sharedInstance.awsEditor?.getUserInfoById(self.txtDialog.text!)
                self.v_refresh.beginRefreshing()
            }
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Email"
            self.txtDialog = textField
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tbe_friend_table: UITableView!
    @IBOutlet weak var lbl_my_info: UILabel!
    let friendsDemo : [String] = ["Peter","Alice","John","Kenneth","Anna","Julie","Matthew","Jake","Wilson","Sam","Paul"]
    var friendsID : NSMutableArray = []
    var friends : NSMutableArray = []
    var selected_index = -1
    var your_have_no_friend_identifier = false
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if your_have_no_friend_identifier {
            return 1
        } else {
            return friends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        if your_have_no_friend_identifier {
            cell.textLabel?.text = "No Result :("
            cell.detailTextLabel?.text? = "I tried sorry :'("
        }
        else {
            let friend:NSDictionary = friends[indexPath.row] as! NSDictionary
            let a = friend.object(forKey: c.TAG_USER_COURSE_LIST) as! Set<String>
            cell.textLabel?.text = friend.object(forKey: c.TAG_USER_NAME) as? String
            cell.detailTextLabel?.text? = "\(a) Year \(friend.object(forKey: c.TAG_JOIN_YR) as! Int)"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !your_have_no_friend_identifier {
            selected_index = indexPath.row
            performSegue(withIdentifier: "segue_friend_profile", sender: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_friend_profile" {
            log.d("HEYYY")
            
            let target:FriendProfileViewController = segue.destination as! FriendProfileViewController
            target.dict_info = friends[selected_index] as! NSDictionary
            
        }
        
    }
    
    func didGetItemSucceedWithItem(_ itemType:String, item:NSDictionary?){
        log.d("Get Succeed, \(itemType)")
        
        if itemType == c.TYPE_USER_SUBS {
            if item != nil {
                your_have_no_friend_identifier = false
                friendsID = NSMutableArray(array: Array(item?.object(forKey: c.TAG_SUBS_LIST) as! Set<String>))
                Appdata.sharedInstance.mySubsList = friendsID
                for var i in 0..<friendsID.count {
                    if (friendsID[i] as! String) != Appdata.sharedInstance.myUserID {
                        Appdata.sharedInstance.awsEditor?.getUserInfoById(friendsID[i] as! String)
                    } else {
                        friendsID.removeObject(at: i)
                    }
                }
            } else {
                log.d("YOU HAVE NO FRIEND :(")
                your_have_no_friend_identifier = true
                DispatchQueue.main.async {
                    self.tbe_friend_table.reloadData()
                }
            }
        }
            
        else if itemType == c.TYPE_USER_INFO {
            
            if item != nil // Item found
            {
                DispatchQueue.main.async {
                    self.v_refresh.endRefreshing()
                }
                if (item?.object(forKey: c.TAG_USER_ID) as! String) == Appdata.sharedInstance.myUserID { // its yourself
                    Appdata.sharedInstance.myInfo = NSMutableDictionary(dictionary: item!)
                    log.d("\(item)")
                    log.d("\(Appdata.sharedInstance.myInfo)")
                    updateMyInfo()
                }
                else {
                    your_have_no_friend_identifier = false
                    log.d("hi")
                    DispatchQueue.main.async {
                        self.friends.add(item)
                        self.tbe_friend_table.reloadData()
                    }
                }
            }
            
        }
    }
    
    func updateMyInfo (){
        DispatchQueue.main.async {
            let a:String = Appdata.sharedInstance.myInfo.object(forKey: c.TAG_USER_NAME) as! String
            self.lbl_my_info.text = "Hello, \(a)!"
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
        Appdata.sharedInstance.awsEditor?.getUserInfoById(Appdata.sharedInstance.myUserID)
        v_refresh.backgroundColor = UIColor.clear
        v_refresh.addTarget(self, action: "pulled", for: UIControlEvents.valueChanged)
        tbe_friend_table.addSubview(v_refresh)
    }
    
    func pulled(){
        friends = []
        tbe_friend_table.reloadData()
        var your_have_no_friend_identifier = false
        Appdata.sharedInstance.awsEditor?.getSubscribleList(Appdata.sharedInstance.myUserID)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setup delegate
        log.d("add delegate")
        Appdata.sharedInstance.awsEditor?.delegate = self
        friends = []
        tbe_friend_table.reloadData()
        var your_have_no_friend_identifier = false
        Appdata.sharedInstance.awsEditor?.getSubscribleList(Appdata.sharedInstance.myUserID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        log.d("dismiss delegate")
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
