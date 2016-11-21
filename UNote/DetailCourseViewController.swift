//
//  DetailCourseViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 21/10/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit


class DetailCourseViewController: UIViewController, UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDelegate, UserTableEditorCallBackProtocol,UserUploadDownloadCallBackProtocol {
    @IBOutlet weak var notePhotoCollection: UICollectionView!
    var list_ready = false
    var filesInThisCourse : NSMutableArray = []
    var thisCourseTitle : String!
    var searchBarAction: Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refresher : UIRefreshControl!
    var dataSource: [NSDictionary] = []
    var dataSourceForSearchResult: [NSDictionary] = []
    var imageDataSetDict:NSMutableDictionary = [:]
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func didUploadFileSucceedWith(_ fileid: String) {
        
    }
    
    func didUploadFileFailedWith(_ fileid: String, error: String) {
        
    }
    func didDownloadFileSucceedWith(_ fileid: String, data: NSData) {
        
        imageDataSetDict[fileid] = data
        
        print("========")
        print(fileid)
        
        notePhotoCollection.reloadData()
    }
    
    
    func didDownloadFileFailedWith(_ fileid: String, error: String) {
        
        print("shshsh")
        print(fileid)
        print(error)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
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
        Appdata.sharedInstance.awsEditor?.fileManager = self
        //notePhotoCollection.reloadData()
        
        
    Appdata.sharedInstance.awsEditor?.getUserFilesListTable(Appdata.sharedInstance.myUserID)
        
        
            notePhotoCollection.reloadData()
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        Appdata.sharedInstance.awsEditor?.delegate = nil
        Appdata.sharedInstance.awsEditor?.fileManager = nil
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

        let prefix = "public/"
        
        if self.searchBarAction {
            
            let note = self.dataSourceForSearchResult[indexPath.row] as! NSMutableDictionary
            
            let fileId = note.object(forKey: c.TAG_FILE_ID) as! String
            
            
            
            let fileName = note.object(forKey: c.TAG_FILE_NAME) as! String
            
            let img = cell.contentView.viewWithTag(1) as! UIImageView
            
            let imag_identity = cell.contentView.viewWithTag(2) as! UILabel
            
            
            if let noteImageDownloaded :NSData = imageDataSetDict.object(forKey: prefix+fileId) as? NSData{
            
                
                img.image = UIImage(data: noteImageDownloaded as Data)
                
                
                
            }else{
                img.image = UIImage(named: "Folder")
            }
            
            
            imag_identity.text = fileName

            
            
            
        }else if self.searchBarAction == false {
            
        
            
            
            let note = self.dataSource[indexPath.row] as! NSMutableDictionary
            
            let fileId = note.object(forKey: c.TAG_FILE_ID) as! String
            
            let fileName = note.object(forKey: c.TAG_FILE_NAME) as! String
            
            let img = cell.contentView.viewWithTag(1) as! UIImageView
            
            let imag_identity = cell.contentView.viewWithTag(2) as! UILabel
            
            
            if let noteImageDownloaded :NSData = imageDataSetDict.object(forKey:prefix+fileId) as? NSData{
                
                
                img.image = UIImage(data: noteImageDownloaded as Data)
                
                
                print("sssssssss")
                
            }else{
                
                print("ffffffffff")
                img.image = UIImage(named: "Folder")
            }
            
            
            imag_identity.text = fileName

            
            
            
            
        }
        
        cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        
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
        
            let selectedImageView = selectedCell.contentView.viewWithTag(1) as! UIImageView
        
            let selectedImage = selectedImageView.image
        
        
        
            
            expandImage.image = selectedImage
            

        
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
                    
                    
                    let fileId = item?.object(forKey: c.TAG_FILE_ID) as! String
                    
                    
                    //let str = item?.object(forKey: c.TAG_FILE_NAME) as! String
                    
                    //dataSource.append(str)
                    
                    dataSource.append(item!)
                    
                    Appdata.sharedInstance.awsEditor?.downloadFile(fileid: fileId)
                    
                    
                    
                }else{
                    print("this item is not from this course")
                    
                    print(itemCourse)
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
        /*
        self.dataSourceForSearchResult = self.dataSource.filter({ (text:String) -> Bool in
            //return text.contains(searchText)
        
            return text.lowercased().range(of: searchText.lowercased()) != nil
        })
        */
        
        self.dataSourceForSearchResult = self.dataSource.filter({
            (item:NSDictionary) -> Bool in
            
            return (item.object(forKey: c.TAG_FILE_NAME) as! String).lowercased().range(of: searchText.lowercased()) != nil
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
