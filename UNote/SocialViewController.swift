//
//  SocialViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class SocialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    // data source
    let friends: [String] = ["Peter","Alice","John","Kenneth","Anna","Julie","Matthew","Jake","Wilson","Sam","Paul"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = friends[indexPath.row]
        
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
