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
    var searchBarAction: Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refresher : UIRefreshControl!
    var dataSource:[String]=[]
    var dataSourceForSearchResult:[String]=[]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.dataSourceForSearchResult = [String]()
        
        self.searchBar.delegate = self
        
        
        self.notePhotoCollection.delegate = self
        self.notePhotoCollection.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTappedOnView(sender:)))
        
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
        
        
        
        refresher = UIRefreshControl()
        self.notePhotoCollection.alwaysBounceHorizontal = true
        refresher.backgroundColor = UIColor.red
        refresher.backgroundColor = UIColor.yellow
        refresher.tintColor = UIColor.brown
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        
        self.notePhotoCollection.addSubview(refresher)
        
        let getCourseNameDefault = UserDefaults.standard
        
        if let val = getCourseNameDefault.string(forKey: "SaveCourseNameInDetailController") {
            
            self.navigationItem.title = val
            self.thisCourseTitle = val
            getCourseNameDefault.synchronize()
        }
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
        notePhotoCollection.reloadData()
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(Appdata.sharedInstance.myUserID)
       
    }
    
    
    
    func loadData()
    {
        //code to execute during refresher
        
        self.notePhotoCollection.reloadData()
        
        stopRefresher()         //Call this to stop refresher
    }
    
    
    
    func stopRefresher()
    {
        //
        
        self.refresher.endRefreshing()
    }

    
    
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        //return self.valid2ShownTakenPhotoData.count no use anymore
     //   return filesInThisCourse.count
        
        if self.searchBarAction {
            return self.dataSourceForSearchResult.count
        }
        
        return self.dataSource.count
    
    
    
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell

        if self.searchBarAction {
            
            let note = self.dataSourceForSearchResult[indexPath.row]
            
            var img = cell.contentView.viewWithTag(1) as! UIImageView
            
            let imag_identity = cell.contentView.viewWithTag(2) as! UILabel
            
            img.image = UIImage(named: "Folder")
            
            imag_identity.text = note
        
        }else if self.searchBarAction == false {
            
        
            
            
            let noteItem = dataSource[indexPath.row]
            
            print("test hi")
            print(noteItem)
            
            var img = cell.contentView.viewWithTag(1) as! UIImageView
            
            let imag_identity = cell.contentView.viewWithTag(2) as! UILabel
            
            img.image = UIImage(named: "Folder")
            
            
            imag_identity.text = noteItem
            
            
        }
        
        
        
        
        
        
        cell.backgroundColor = UIColor.red
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
        
            /* no use anymore, u can reference
            selectedIndexPath = indexPath
            self.notePhotoCollection.performBatchUpdates(nil, completion: nil)
            */
            
            let selectedCell : UICollectionViewCell = notePhotoCollection.cellForItem(at: indexPath)!
            print((selectedCell.contentView.viewWithTag(2) as! UILabel).text)
            
            let expandImage = self.view.viewWithTag(3) as! UIImageView
            
            
            expandImage.image = UIImage(named: "Friends")
            
            expandImage.isHidden = false
        
        
        
        
        
        
        
    }
    
    func didSetItemWith(_ state: Bool, itemType: String) {
        
        // may not use in this situation
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
                    
                    let str = item?.object(forKey: c.TAG_FILE_NAME) as! String
                    
                    dataSource.append(str)
                    
                    
                
                }else{
                    print("this item is not from this course")
                }
                
                DispatchQueue.main.async{
                    
                    self.notePhotoCollection.reloadData()
                    
                    
                }
                
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        

        
        if searchText.characters.count > 0{
            
            
            self.searchBarAction = true
            
            self.filterContentForSearchText(searchText: searchText)
            self.notePhotoCollection.reloadData()
        }else{
            
            self.searchBarAction = false
            self.notePhotoCollection.reloadData()
            
            
        }
        
        
        
    }
    
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
        self.searchBar.setShowsCancelButton(true, animated: true)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self .cancelSearching()
        
        self.notePhotoCollection.reloadData()
    }
    
    
    func cancelSearching(){
        self.searchBarAction = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    
        if searchText.characters.count > 0 {
            
            self.searchBarAction = true
            self.filterContentForSearchText(searchText: searchText)
            
            self.notePhotoCollection.reloadData()
            
            
            
        }else{
            
            self.searchBarAction = false
            
            self.notePhotoCollection.reloadData()
        
        
        }
        
        
    }
    
    
    func filterContentForSearchText(searchText:String){
        self.dataSourceForSearchResult = self.dataSource.filter({ (text:String) -> Bool in
            return text.contains(searchText)
        })
        

        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBarAction = true
        self.view.endEditing(true)
        
    }
    
    
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.searchBarAction = false
        self.searchBar.setShowsCancelButton(false, animated: false)
        
    }
    
    
    
    func doubleTappedOnView(sender: UITapGestureRecognizer){
        
        
        let expandedImage = self.view.viewWithTag(3) as! UIImageView
        
        expandedImage.image = nil
        expandedImage.isHidden = true
        
    }
    
}
