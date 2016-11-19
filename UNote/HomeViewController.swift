//
//  HomeViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate, UserTableEditorCallBackProtocol {
    
    // data source
    let files:NSMutableArray = []
    var list_ready = false
    var searchBarAction = false

    
    var subjectList : [String] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let leftAndRightPaddings: CGFloat = 0.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    //private let heightAdjustment: CGFloat = 30.0
    private var itemWidth: CGFloat = 200.0
    var dataSourceForSearchResult:[String] = []
    var refreshControl : UIRefreshControl!
    var selectedFolder:UICollectionViewCell!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Toolbar must be hidden until you press Edit button
        editNoteToolbar.isHidden = true
        
        //let layout = collectionView.collectionViewLayout
        //layout.
        //let layout = collectionView as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width: width,height: width + heightAdjustment)
        
        
        searchBar.delegate = self
        refreshControl = UIRefreshControl()
        
        self.collectionView!.alwaysBounceVertical = true
        
        refreshControl.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        self.dataSourceForSearchResult = [String]()
        
        
        self.collectionView.addSubview(refreshControl)

    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return files.count
        
        
        var removedFileList = UserDefaults.standard.value(forKey: "UserRemoveSubjectFolderList") as! [String]
        
        
        for folder in removedFileList {
            
            
            
            if let idx = dataSourceForSearchResult.index(of: folder){
                
                dataSourceForSearchResult.remove(at: idx)
            }
            
            if let idx = subjectList.index(of: folder){
                
                subjectList.remove(at: idx)
            }
            
            
        }
        
        
        
        if self.searchBarAction{
            return self.dataSourceForSearchResult.count
            
        }
        
        
        return subjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as UICollectionViewCell
        folderCell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        /* by wai, hide for a while
        
        let dict_file:NSDictionary = files[indexPath.row] as! NSDictionary
        log.d("index: \(indexPath.row)")
        // Set Subject name
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        value.adjustsFontSizeToFitWidth = true
        value.minimumScaleFactor = 0.1
       // value.text = dict_file.object(forKey: c.TAG_FILE_NAME) as! String
        
        */
        
        //test
        
        
        if self.searchBarAction{
            
            let one_subject = self.dataSourceForSearchResult[indexPath.row]
            
            
            let subjectlabel = folderCell.contentView.viewWithTag(2) as! UILabel
            subjectlabel.adjustsFontSizeToFitWidth = true
            subjectlabel.minimumScaleFactor = 0.1
            
            subjectlabel.text = one_subject
            
            let subjectFolder = folderCell.contentView.viewWithTag(1) as! UIImageView
            
            subjectFolder.image = UIImage(named: "Folder")
            
            
            
        } else if self.searchBarAction == false{
            
            
            let one_subject = subjectList[indexPath.row]
            
            let subjectlabel = folderCell.contentView.viewWithTag(2) as! UILabel
            subjectlabel.adjustsFontSizeToFitWidth = true
            subjectlabel.minimumScaleFactor = 0.1
            
            subjectlabel.text = one_subject
            
            let subjectFolder = folderCell.contentView.viewWithTag(1) as! UIImageView
            
            subjectFolder.image = UIImage(named: "Folder")
            
        }
        
        /*
        //test..........
        let one_subject = subjectList[indexPath.row]
        
        let subjectlabel = folderCell.contentView.viewWithTag(2) as! UILabel
        subjectlabel.adjustsFontSizeToFitWidth = true
        subjectlabel.minimumScaleFactor = 0.1
        
        subjectlabel.text = one_subject
        
        let subjectFolder = folderCell.contentView.viewWithTag(1) as! UIImageView
        
        subjectFolder.image = UIImage(named: "Folder")
        
        //=====================================
        
 */
   
        
        /* by wai, hide for a while
        
        // Set File image
        let img = folderCell.contentView.viewWithTag(1) as! UIImageView
        if (value.text?.contains(".pdf"))! {
            img.image = UIImage(named: "file_pdf")
        }
        else if (value.text?.contains(".doc"))! {
            img.image = UIImage(named: "file_doc")
        }
        else if (value.text?.contains(".png"))! || (value.text?.contains(".jpg"))!{
            img.image = UIImage(named: "file_img")
        }
        else {
            img.image = UIImage(named: "file_unknown")
        }
 
 
        */
        
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
    
    func didGetItemSucceedWithItem(_ itemType:String, item:NSDictionary?){
        log.d("Get Succeed, \(itemType)")
        
        
        if itemType == c.TYPE_USER_FILE {
            if item != nil {
                
                list_ready = true
                Appdata.sharedInstance.myFileList = NSMutableArray(array:Array(item?.object(forKey: c.TAG_FILE_LIST) as! Set<String>))
                
                
                files.removeAllObjects()
                for var i in 0..<Appdata.sharedInstance.myFileList.count {
                    Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(Appdata.sharedInstance.myFileList[i] as! String)
                }
            }
        }
            
        else if itemType == c.TYPE_FILE {
            
            if item != nil // Item found
            {
                files.add(item)
                
                
                
                
                
                
                
                if !subjectList.contains(item?.object(forKey: c.TAG_FILE_COURSE) as! String) {
                    subjectList.append(item?.object(forKey: c.TAG_FILE_COURSE) as! String)
                    
                    
                    
                    
                    
                }
                
                DispatchQueue.main.async {
                    
                    self.collectionView.reloadData()
                    
                }
            }
            
        }
    }
    
    func didSetItemWith(_ state:Bool, itemType:String){
        log.d("Set Succeed")
        if state && itemType == c.TYPE_FILE { // create file succeed
            Appdata.sharedInstance.awsEditor?.setUserFilesListTable(Appdata.sharedInstance.myFileList) // update list
            Appdata.sharedInstance.awsEditor?.getFileInfoByfileId(Appdata.sharedInstance.myFileList.lastObject as! String) // request added object
        }
    }
    
    func didGetItemFailedWithError(_ itemType:String, error:String){
        log.d("Error Handling")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // setup delegate
        Appdata.sharedInstance.awsEditor?.delegate = self
        list_ready = false
        files.removeAllObjects()
        
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(Appdata.sharedInstance.myUserID)
        
        
        collectionView.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss delegate
        Appdata.sharedInstance.awsEditor?.delegate = nil
    }
    
    @IBAction func editButtonPressed(_ sender: AnyObject) {
        if editModeEnabled {
            editNoteToolbar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            
            editBarButton.title = "Edit"
            editBarButton.style = .plain
            
            editModeEnabled = false
            
        } else {
            editNoteToolbar.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            
            editBarButton.title = "Done"
            editBarButton.style = .done
            
            editModeEnabled = true
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell : UICollectionViewCell = collectionView.cellForItem(at: indexPath){
            if editModeEnabled {
                
                if cell.backgroundColor == #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) {
                    // Selected cell
                    cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                } else {
                    // Deselected cell
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                
                
                
                
                self.selectedFolder = cell
                
            } else {
                
                let passValStand = UserDefaults.standard
                
                let valLabel = cell.contentView.viewWithTag(2) as! UILabel!
                
                if let setVal = valLabel {
                    
                    passValStand.set(setVal.text, forKey: "SaveCourseNameInDetailController")
                    
                    passValStand.synchronize()
                    
                    performSegue(withIdentifier: "detailCourse", sender: nil)
                    
                }
            }
        }
        
        
        
        
        
    }

    
    func loadData() {
        //code to execute during refresher
    
        Appdata.sharedInstance.awsEditor?.delegate = self
        list_ready = false
        files.removeAllObjects()
            
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(Appdata.sharedInstance.myUserID)
        
        collectionView.reloadData()
            
        
        stopRefresher()         //Call this to stop refresher
        
    }
    
    func stopRefresher() {
    
        self.refreshControl.endRefreshing()
    
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            self.searchBarAction = true
            self.filterContentForSearchText(searchText: searchText)
            
            self.collectionView.reloadData()
            
        } else {
            
            self.searchBarAction = false
            self.collectionView.reloadData()
        }
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        self.searchBarAction = false
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.cancelSearching()
        self.collectionView.reloadData()
        
    }
    
    func cancelSearching() {
        
        self.searchBarAction = false
        
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBarAction = true
        self.view.endEditing(true)
        
    }
    
    
    
    
    func filterContentForSearchText(searchText:String){
        self.dataSourceForSearchResult = self.subjectList.filter({ (text:String) -> Bool in
            
            return text.lowercased().range(of: searchText.lowercased()) != nil
            //return text.contains(searchText)
        })
        
        
        
    }
    
    
    //
    // TOOLBAR - Edit View Mode
    //
    
    var editModeEnabled = false
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    @IBOutlet weak var editNoteToolbar: UIToolbar!
    
    @IBAction func addNewNotes(_ sender: Any) {
        let optionMenu = UIAlertController(title: "Add file", message: "What kind of file would you like to add?", preferredStyle: .alert)
        
        let Action1 = UIAlertAction(title: "-DEMO- PNG", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            let fileid:String = String(c.getTimestamp())
            //            let image = UIImage(named: "teach.jpg")
            //            let data = UIImagePNGRepresentation(image!)
            //            Appdata.sharedInstance.awsEditor?.uploadWithData(data: data! as NSData, forKey: "abcabcabc")
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: fileid+".png", course: "EE4304", fileLink: "/file/")
        })
        
        let Action2 = UIAlertAction(title: "-DEMO- PDF", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            let fileid:String = String(c.getTimestamp())
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: fileid+".pdf", course: "EE4304", fileLink: "/file/")
        })
        
        
        
        let Action3 = UIAlertAction(title: "-DEMO- DOC", style: .default, handler: {(alert: UIAlertAction!) -> Void in
            let fileid:String = String(c.getTimestamp())
            Appdata.sharedInstance.myFileList.add(fileid)
            Appdata.sharedInstance.awsEditor?.setFileInfo(fileid, name: fileid+".doc", course: "EE4304", fileLink: "/file/")
        })
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) -> Void in
        })
        
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        
        optionMenu.addAction(Action1)
        optionMenu.addAction(Action2)
        optionMenu.addAction(Action3)
        optionMenu.addAction(Cancel)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func addNewCourse(_ sender: Any) {
    }
    
    @IBAction func shareFiles(_ sender: Any) {
    }
    
    @IBAction func deleteFiles(_ sender: Any) {
        
        
        if editModeEnabled{
            
            
            let deletedTargetFolderLabel = selectedFolder.contentView.viewWithTag(2) as! UILabel
            
            
            var deletedTargetFolderNameList : [String] = []
            
            
            if let remove_folderNameList = UserDefaults.standard.object(forKey: "UserRemoveSubjectFolderList")  {
                
                deletedTargetFolderNameList = remove_folderNameList as! [String]
                
                deletedTargetFolderNameList.append(deletedTargetFolderLabel.text!)
                
                UserDefaults.standard.set(deletedTargetFolderNameList, forKey: "UserRemoveSubjectFolderList")
                
                print("==")
                print(UserDefaults.standard.value(forKey: "UserRemoveSubjectFolderList"))
                
            }else{
                
            
                

                deletedTargetFolderNameList.append(deletedTargetFolderLabel.text!)
                
                
                
                UserDefaults.standard.set(deletedTargetFolderNameList, forKey: "UserRemoveSubjectFolderList")
                
                
                print("==")

                print(UserDefaults.standard.value(forKey: "UserRemoveSubjectFolderList"))
                
                
            }
            
            
            
            collectionView.reloadData()
            
            
            
            
        }else{
            
            
            
            
        }
        
    }
    
}








