//
//  SplashViewController.swift
//  UNote
//
//  Created by Paul Yeung on 22/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var txt_title:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // application setup
        let appdata:Appdata = Appdata.sharedInstance
        appdata.awsEditor = UserTableEditor()
        // Splash timer, go home or reg page if not reg yet
        let timer:Timer! = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(go), userInfo: nil, repeats: false)
        
        self.txt_title.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.txt_title.alpha = 1.0
        }
    }
    
    func go()
    {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.txt_title.alpha = 0.0
            }) { (com) in
                
                DispatchQueue.main.async {
                    if UserDefaults.standard.string(forKey: c.SAVED_USER_ID) != nil
                    {
                        log.d("HEY")
                        Appdata.sharedInstance.myUserID = UserDefaults.standard.string(forKey: c.SAVED_USER_ID)!
                        self.performSegue(withIdentifier: "segue_go_home", sender: nil)
                    }
                    else
                    {
                        log.d("YOO")
                        self.performSegue(withIdentifier: "segue_go_reg", sender: nil)
                    }
                }
                
        }
        
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
