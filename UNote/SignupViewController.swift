//
//  RegisterViewController.swift
//  UNote
//
//  Created by Paul Yeung on 21/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit
import Foundation

class SignupViewController: UIViewController, UserTableEditorCallBackProtocol {
    
    // flow
    // On pressed -> check if the ID used
    //      - create ID if available
    //          ->save in UserDefaults and go home page
    //
    //      - enter again if used
    
    @IBOutlet weak var v_loading: UIView!
    @IBOutlet weak var txt_IDField: UITextField!
    @IBOutlet weak var txt_PWField: UITextField!
    @IBOutlet weak var txt_PW2Field: UITextField!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_join_course: UITextField!
    @IBOutlet weak var txt_join_yr: UITextField!
    
    var idFinished = false
    var profileFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v_loading.frame = self.view.frame
        v_loading.subviews[0].center = v_loading.center
        
    }
    
    func setLoading(state:Bool){ // the gray loading view
        if state {
            v_loading.isHidden = false
            self.view.bringSubview(toFront: v_loading)
        } else {
            v_loading.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func pressed(_ sender: AnyObject) {
        
        idFinished = false
        profileFinished = false
        
        if txt_IDField.text != "" && txt_name.text != "" && txt_join_course.text != "" && txt_PWField.text != "" && txt_PWField.text == txt_PW2Field.text , let _ = Int(txt_join_yr.text!) {
            setLoading(state: true)
            Appdata.sharedInstance.awsEditor?.getUserInfoById(txt_IDField.text!)
            //        Appdata.sharedInstance.awsEditor?.scanAllUser()
        } else {
            let alert=UIAlertController(title: "ERROR", message: "Wrong data input. Please enter again", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
            self.show(alert, sender: self);
        }
        
    }
    
    
    func didGetItemSucceedWithItem(_ itemType:String, item:NSDictionary?){
        log.d("Get Succeed")
        
        if itemType == c.TYPE_USER_INFO {
            
            if item != nil // Item found, ie. id is used go pick another
            {
                log.d("hi")
                DispatchQueue.main.async { // do in main UI Thread
                    let alert=UIAlertController(title: "ERROR", message: "This ID has been used. Please enter a new one", preferredStyle: UIAlertControllerStyle.alert);
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
                    self.show(alert, sender: self);
                }
                
            }
            else // Item not found, OK =3=+
            {
                log.d("hey")
                Appdata.sharedInstance.awsEditor?.setMyAccount(self.txt_IDField.text!, pw: self.txt_PWField.text!)
            }
        }
    }
    
    func didSetItemWith(_ state:Bool, itemType:String){
        log.d("Set, \(itemType), \(state)")
        
        if state {
            if itemType == c.TYPE_ACCOUNT {
                Appdata.sharedInstance.myUserID = txt_IDField.text!
                idFinished = true
                let courses : Set<String> = [txt_join_course.text!]
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMddhhmmss"
                let timestamp = Int(formatter.string(from: Date()))
                Appdata.sharedInstance.awsEditor?.setUserInfo(courses, joinTimestamp: timestamp, joinYr: Int(txt_join_yr.text!), name: txt_name.text!, selfIntro: "YOOOOOO")
                log.d("HEYYY")
            } else if itemType == c.TYPE_USER_INFO {
                profileFinished = true
            }
            
            if idFinished && profileFinished {
                DispatchQueue.main.async {
                    self.setLoading(state: false)
                        self.performSegue(withIdentifier: "segue_reg_done", sender: self)
                }
                UserDefaults.standard.set(txt_IDField.text!, forKey: c.SAVED_USER_ID)
            }
        }
    }
    
    func didGetItemFailedWithError(_ itemType:String, error:String){
        log.d("Error Handling")
        setLoading(state: false)
        DispatchQueue.main.async {
            let alert=UIAlertController(title: "ERROR", message: "Cannot connect to server", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
            self.show(alert, sender: self);
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss delegate
        Appdata.sharedInstance.awsEditor?.delegate = nil
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
