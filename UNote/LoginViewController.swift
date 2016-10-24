//
//  LoginViewController.swift
//  UNote
//
//  Created by David Ivorra on 21/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UserLoginProtocol, UITextFieldDelegate{
    
    
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_pw: UITextField!
    @IBOutlet weak var v_loading: UIView!
    
    @IBAction func loginButton(_ sender: AnyObject) {
        if txt_email.text != nil && txt_pw.text != nil {
            setLoading(state: true)
            Appdata.sharedInstance.awsEditor?.loginAccount(txt_email.text!, pw: txt_pw.text!)
        }
    }
    
    
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didLoginFailed() {
        DispatchQueue.main.async { // do in main UI Thread
            self.setLoading(state: false)
            let alert=UIAlertController(title: "ERROR", message: "ID or Password Incorrect", preferredStyle: UIAlertControllerStyle.alert);
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
            self.show(alert, sender: self);
        }
    }
    
    func didLoginSucceed(_ email: String) {
        Appdata.sharedInstance.myUserID = email
        UserDefaults.standard.set(email, forKey: c.SAVED_USER_ID)
        DispatchQueue.main.async {
            self.setLoading(state: false)
            self.performSegue(withIdentifier: "segue_login_home", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Appdata.sharedInstance.awsEditor?.loginer = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Appdata.sharedInstance.awsEditor?.loginer = nil
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        txt_email.resignFirstResponder()
        txt_pw.resignFirstResponder()

    }
}
