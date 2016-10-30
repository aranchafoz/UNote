//
//  DetailCourseViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 21/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit


class DetailCourseViewController: UIViewController, UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDelegate, UserTableEditorCallBackProtocol {
    @IBOutlet weak var notePhotoCollection: UICollectionView!
    var list_ready = false
    var filesInThisCourse : NSMutableArray = []
    var thisCourseTitle : String!
    
//    var photoCoreStack = CourseListCore()
//    var takenPhotoData : [TakenPhoto] = []
//    var valid2ShownTakenPhotoData : [TakenPhoto] = []
//    var selectedIndexPath : IndexPath!
    
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
            self.thisCourseTitle = val
            getCourseNameDefault.synchronize()
        }
        
        
        
        
        
        
        
        
        /*
        
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
        */
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
        notePhotoCollection.reloadData()
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(Appdata.sharedInstance.myUserID)
       
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
        //return self.valid2ShownTakenPhotoData.count no use anymore
        return filesInThisCourse.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
    
        // Configure the cell
//    
//        let img  = cell.contentView.viewWithTag(1) as! UIImageView
        //get image
        
        //let imgIdentity = cell.contentView.viewWithTag(2) as! UILabel
        
        
        //imgIdentity.text = self.valid2ShownTakenPhotoData[indexPath.item].noteTitle
        
        let noteItem : NSDictionary = filesInThisCourse[indexPath.row] as! NSDictionary
        
        var img = cell.contentView.viewWithTag(1) as! UIImageView
        
        let imag_identity = cell.contentView.viewWithTag(2) as! UILabel
        
        img.image = UIImage(named: "Folder")
    
        
        imag_identity.text = noteItem.object(forKey: c.TAG_FILE_NAME) as! String?
        
        
        
        
        
        
        cell.backgroundColor = UIColor.cyan
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
            /* no use anymore, u can reference
            selectedIndexPath = indexPath
            self.notePhotoCollection.performBatchUpdates(nil, completion: nil)
            
            
            let selectedCell : UICollectionViewCell = notePhotoCollection.cellForItem(at: indexPath)!
            print((selectedCell.contentView.viewWithTag(2) as! UILabel).text)
            
            let expandImage = self.view.viewWithTag(3) as! UIImageView
            
            
            //expandImage.image = UIImage(named: "Friends")
            
            expandImage.isHidden = false
            */
        
        
        
        
        
        
    }
    
    func didSetItemWith(_ state: Bool, itemType: String) {
        
        
    }
    
    
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
    }
    
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        
        if itemType == c.TYPE_USER_FILE {
            
            if item != nil{
                
                
                list_ready = true
                
                Appdata.sharedInstance.myFileList = NSMutableArray(array: Array(item?.object(forKey: c.TAG_FILE_LIST) as! Set<String>))

                
                filesInThisCourse.removeAllObjects()
                
                for var i in 0..<Appdata.sharedInstance.myFileList.count{
                    
                    Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(Appdata.sharedInstance.myFileList[i] as! String)
                    
                    
                }
                
                
                
            }
            
            
        }else if itemType == c.TYPE_FILE{
            
            //found item
            if item != nil{
                
                let itemCourse = item?.object(forKey: c.TAG_FILE_COURSE) as! String
                if itemCourse == self.thisCourseTitle {
                
                    
                    
                    filesInThisCourse.add(item)
                    
                }else{
                    print("this item is not from this course")
                }
                
                DispatchQueue.main.async{
                    
                    self.notePhotoCollection.reloadData()
                
                }
                
                
            }
            
            
            
            
        }
        
        
        
    }
    
    
    func doubleTappedOnView(sender: UITapGestureRecognizer){
        
        
        let expandedImage = self.view.viewWithTag(3) as! UIImageView
        
        expandedImage.image = nil
        expandedImage.isHidden = true
        
    }
    
}
