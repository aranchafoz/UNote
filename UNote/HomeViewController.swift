//
//  HomeViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // data source
    private var numberOfFolders = 9
    
    private let leftAndRightPaddings: CGFloat = 0.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    //private let heightAdjustment: CGFloat = 30.0
    private var itemWidth: CGFloat = 200.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                //let layout = collectionView.collectionViewLayout
        //layout.
        //let layout = collectionView as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width: width,height: width + heightAdjustment)
    }
    
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
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //itemWidth = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow

    }
 

}
