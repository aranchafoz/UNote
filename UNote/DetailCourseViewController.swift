//
//  DetailCourseViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 21/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit


class DetailCourseViewController: UIViewController, UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDelegate {
    @IBOutlet weak var notePhotoCollection: UICollectionView!

    var photoCoreStack = CourseListCore()
    var takenPhotoData : [TakenPhoto] = []
    var valid2ShownTakenPhotoData : [TakenPhoto] = []
    var selectedIndexPath : IndexPath!
    
    
    func createSearchBar(){
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter search text"
        searchBar.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        

        // Do any additional setup after loading the view.
        //self.createSearchBar()
        
        self.notePhotoCollection.delegate = self
        self.notePhotoCollection.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTappedOnView(sender:)))
        
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
        
        
        
        
        let getCourseNameDefault = UserDefaults.standard
        
        if let val = getCourseNameDefault.string(forKey: "SaveCourseNameInDetailController") {
            
            self.navigationItem.title = val
            
            getCourseNameDefault.synchronize()
        }
        
        
        
        
        
        
        let data_context = photoCoreStack.persistentContainer.viewContext
        
        do{
        
            try
                takenPhotoData = data_context.fetch(TakenPhoto.fetchRequest())
            
    
            
            
            if takenPhotoData.count > 0 {
            
                for eachNote in takenPhotoData {
                   
                    if eachNote.courseName == self.navigationItem.title
                    {
                    
                        
                        valid2ShownTakenPhotoData.append(eachNote)
                        
                        print("this belong to this course")
                        print(eachNote.courseName)
                        print(self.navigationItem.title)
                    
                        
                    }else{
                        print("this note is not belong to this course")
                    }
                    
                }
            
            }else{
                
                print("no note on this course")
            }
            
            
            
        }catch{
            
            
            
        }
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.valid2ShownTakenPhotoData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
    
        // Configure the cell
//    
//        let img  = cell.contentView.viewWithTag(1) as! UIImageView
        //get image
        
        let imgIdentity = cell.contentView.viewWithTag(2) as! UILabel
        
        
        imgIdentity.text = self.valid2ShownTakenPhotoData[indexPath.item].noteTitle
        
        
        
        
        cell.backgroundColor = UIColor.cyan
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
            
            selectedIndexPath = indexPath
            self.notePhotoCollection.performBatchUpdates(nil, completion: nil)
            
            
            let selectedCell : UICollectionViewCell = notePhotoCollection.cellForItem(at: indexPath)!
            print((selectedCell.contentView.viewWithTag(2) as! UILabel).text)
            
            let expandImage = self.view.viewWithTag(3) as! UIImageView
            
            
            //expandImage.image = UIImage(named: "Friends")
            
            expandImage.isHidden = false
            
            
        
        
    }
    
    
    func doubleTappedOnView(sender: UITapGestureRecognizer){
        
        
        let expandedImage = self.view.viewWithTag(3) as! UIImageView
        
        expandedImage.image = nil
        expandedImage.isHidden = true
        
    }
    
}
