//
//  FriendCourseFileViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 16/11/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit



class FriendCourseFileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate,UserUploadDownloadCallBackProtocol{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var fileListInThisCourse_name : [String] = []
    var fileList:NSMutableArray = []
    
    var searchBarAction:Bool = false
    var userID : String!
    var courseName : String!
    var filesSaved:[NSDictionary] = []
    var selectedImage:UIImage!
    var dataSourceForSearchResult:[NSDictionary] = []
    var imageDataSetDict:NSMutableDictionary = [:]
    
    
    func didUploadFileSucceedWith(_ fileid: String) {
        
    }
    
    func didDownloadFileFailedWith(_ fileid: String, error: String) {
     
        
        print("wwwwwww")
    }
    
    
    func didDownloadFileSucceedWith(_ fileid: String, data: NSData) {
        
        print("ssssss")
        
        print(fileid)
        imageDataSetDict[fileid] = data
     
        collectionView.reloadData()
        
        
    }
    func didUploadFileFailedWith(_ fileid: String, error: String) {
     
        
        
    }

    
    func longPressed(sender:UILongPressGestureRecognizer){
        
        
        var passImageToSave = self.selectedImage
        
        if passImageToSave != nil {
            
            
            UIImageWriteToSavedPhotosAlbum(passImageToSave!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            
        }
        
    }
    
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        userID = UserDefaults.standard.value(forKey: "userID") as! String!
        courseName = UserDefaults.standard.value(forKey: "course") as! String!
   
        
        filesSaved = UserDefaults.standard.value(forKey: "savedMaterial") as! [NSDictionary]
        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.doubleTappedOnView(sender:)))
        
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)))
        
        
        
        view.addGestureRecognizer(longPressRecognizer)
        
        
        
        
        
        
        for file in filesSaved {
            
            
            print("hihihih")
            
            print(file.object(forKey: c.TAG_FILE_COURSE)  as! String)
            print(file.object(forKey: c.TAG_FILE_NAME) as! String)
            
            
        }
        
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        // seem this is useless , maybe need to delete
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(self.userID)
        
        
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //    Appdata.sharedInstance.awsEditor?.delegate = self
        fileListInThisCourse_name.removeAll()
        Appdata.sharedInstance.awsEditor?.fileManager = self
    
        
        
        for eachFile in filesSaved {
            
            let fileID = eachFile.object(forKey: c.TAG_FILE_ID) as? String
            
        
            print("++++")
            
            if fileID != nil {
            Appdata.sharedInstance.awsEditor?.downloadFile(fileid: fileID!)
            
                
            }else{
                
                Appdata.sharedInstance.awsEditor?.downloadFile(fileid: "2222")
            }
            
            
        }
        
        
        
        collectionView.reloadData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Appdata.sharedInstance.awsEditor?.delegate = nil
        
        Appdata.sharedInstance.awsEditor?.fileManager = nil
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //   return fileListInThisCourse_name.count
        
        
        if self.searchBarAction {
            
            return self.dataSourceForSearchResult.count
        }
        
        return filesSaved.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let file_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "File", for: indexPath) as UICollectionViewCell
        
        
        let prefix = "public/"
        
        if self.searchBarAction{
            
            let note = self.dataSourceForSearchResult[indexPath.row] as! NSMutableDictionary
            
            
            let fileId = note.object(forKey: c.TAG_FILE_ID) as! String
           
            let fileName = note.object(forKey: c.TAG_FILE_NAME) as! String
            
            
            let cell_imageView = file_cell.contentView.viewWithTag(2) as! UIImageView
            
            
            
            let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
            
            
            
            
            if let noteImageDownload:NSData = imageDataSetDict.object(forKey: prefix+fileId) as? NSData {
                
                
                cell_imageView.image = UIImage(data: noteImageDownload as Data)
                
                
                
                
            }else{
                
                
                cell_imageView.image = UIImage(named: "Folder")
            }
            
            
            
            
            
            file_name_onLabel.text = fileName
            
        }else{
            
            
            let note = self.filesSaved[indexPath.row] as! NSMutableDictionary
            
            
            let fileId = note.object(forKey: c.TAG_FILE_ID) as! String
            
            let fileName = note.object(forKey: c.TAG_FILE_NAME) as! String
            
            
            let cell_imageView = file_cell.contentView.viewWithTag(2) as! UIImageView
            
            
            
            let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
            
            
            
            
            if let noteImageDownload:NSData = imageDataSetDict.object(forKey: prefix+fileId) as? NSData {
                
                
                cell_imageView.image = UIImage(data: noteImageDownload as Data)
                
                
                
                
            }else{
                
                print("fff")
                cell_imageView.image = UIImage(named: "Folder")
            }
            
            
            
            file_name_onLabel.text = fileName
            
        }
        
        /*
         let file_name_fromList = self.filesSaved[indexPath.row]
         
         
         let file_image = file_cell.contentView.viewWithTag(2) as! UIImageView
         
         file_image.image = UIImage(named:"Folder")
         
         
         
         let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
         file_name_onLabel.text = file_name_fromList.object(forKey: c.TAG_FILE_NAME) as! String
         
         
         */
        return file_cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let selectedCell:UICollectionViewCell = self.collectionView.cellForItem(at:
            indexPath)!
        
        
        let selectedImageView = selectedCell.contentView.viewWithTag(2) as! UIImageView
        
        
        let selectedImage_ = selectedImageView.image
        
        
        print("click to choose")
        
        let expandImage = self.view.viewWithTag(3) as! UIImageView
        expandImage.image = selectedImage_
        expandImage.isHidden = false
        expandImage.backgroundColor = .blue
        
        self.selectedImage = expandImage.image
        
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0{
            
            
            self.searchBarAction = true
            self.filterContentForSearchText(searchText:searchText)
            self.collectionView.reloadData()
            
        }else{
            
            self.searchBarAction = false
            self.collectionView.reloadData()
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelSearching()
        self.collectionView.reloadData()
    }
    
    func cancelSearching(){
        
        self.searchBarAction = false
        self.searchBar!.resignFirstResponder()
        self.searchBar!.text = ""
    }
    
    func filterContentForSearchText(searchText:String){
        
        
        self.dataSourceForSearchResult = self.filesSaved.filter({
            
            (file:NSDictionary) -> Bool in
            
            return (file.object(forKey: c.TAG_FILE_NAME) as! String).lowercased().range(of: searchText.lowercased()) != nil
            
            
        })
        
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarAction = true
        self.view.endEditing(true)
        
        print("iiii")
    }
    
    
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.searchBarAction = false
        
        self.searchBar.setShowsCancelButton(false, animated: false)
        
        
    }
    
    
    
    
    
    
    
    
    
    func doubleTappedOnView(sender:UITapGestureRecognizer){
        
        
        let expandedImage = self.view.viewWithTag(3) as! UIImageView
        
        expandedImage.image = nil
        expandedImage.isHidden = true
        
        
        
        
        
}

}

