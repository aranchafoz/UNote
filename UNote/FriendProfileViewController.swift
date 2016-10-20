//
//  FriendProfileViewController.swift
//  UNote
//
//  Created by David Ivorra on 20/10/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class FriendProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var profileBackground: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    
    // data source
    private var numberOfFolders = 9
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfFolders
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as UICollectionViewCell
        
        // Set File image
        let img = folderCell.contentView.viewWithTag(1) as! UIImageView
        img.image = UIImage(named: "Folder")
        
        // Set Subject name
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        value.text = "EE4304"
        
        
        return folderCell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        profilePicture.layer.borderWidth = 2.0
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.white.cgColor
        profilePicture.layer.cornerRadius = 13
        profilePicture.layer.cornerRadius = profilePicture.frame.size.height/2
        profilePicture.clipsToBounds = true
        
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
