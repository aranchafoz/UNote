//
//  FriendCourseFileViewController.swift
//  UNote
//
//  Created by SUNGKAHO on 16/11/2016.
//  Copyright © 2016年 EE4304. All rights reserved.
//

import UIKit



class FriendCourseFileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate{
    
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
    
    
    func longPressed(sender:UILongPressGestureRecognizer){
        
        print("long pressed")
        
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
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(self.userID)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //    Appdata.sharedInstance.awsEditor?.delegate = self
        fileListInThisCourse_name.removeAll()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Appdata.sharedInstance.awsEditor?.delegate = nil
        
        
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
        
        
        if self.searchBarAction{
            
            let file_name_fromList = self.dataSourceForSearchResult[indexPath.row]
            
            
            let file_image = file_cell.contentView.viewWithTag(2) as! UIImageView
            
            file_image.image = UIImage(named:"Folder")
            
            
            
            let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
            file_name_onLabel.text = file_name_fromList.object(forKey: c.TAG_FILE_NAME) as! String
            
        }else{
            
            
            let file_name_fromList = self.filesSaved[indexPath.row]
            
            
            let file_image = file_cell.contentView.viewWithTag(2) as! UIImageView
            
            file_image.image = UIImage(named:"Folder")
            
            
            
            let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
            file_name_onLabel.text = file_name_fromList.object(forKey: c.TAG_FILE_NAME) as! String
            
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
        
        print("click to choose")
        
        let expandImage = self.view.viewWithTag(3) as! UIImageView
        expandImage.image = UIImage(named: "Friends")
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



/*
class FriendCourseFileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!

    var fileListInThisCourse_name : [String] = []
    var fileList:NSMutableArray = []
    var userID : String!
    var courseName : String!
    var filesSaved:[NSDictionary] = []
    var selectedImage:UIImage!

    
    
    func longPressed(sender:UILongPressGestureRecognizer){
        
        print("long pressed")
        
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
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(self.userID)
    
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
    //    Appdata.sharedInstance.awsEditor?.delegate = self
        fileListInThisCourse_name.removeAll()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
       // Appdata.sharedInstance.awsEditor?.delegate = nil
        
        
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
    
        return filesSaved.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let file_cell = collectionView.dequeueReusableCell(withReuseIdentifier: "File", for: indexPath) as UICollectionViewCell
        
        let file_name_fromList = self.filesSaved[indexPath.row]
        
        
        let file_image = file_cell.contentView.viewWithTag(2) as! UIImageView
        
        file_image.image = UIImage(named:"Folder")
        
        
        
        let file_name_onLabel = file_cell.contentView.viewWithTag(1) as! UILabel
        file_name_onLabel.text = file_name_fromList.object(forKey: c.TAG_FILE_NAME) as! String
        
        
        return file_cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let selectedCell: UICollectionViewCell = self.collectionView.cellForItem(at:
            indexPath)!
        
        print("click to choose")
        
        let expandImage = self.view.viewWithTag(3) as! UIImageView
        expandImage.image = UIImage(named: "Friends")
        expandImage.isHidden = false
        expandImage.backgroundColor = .blue
        
        self.selectedImage = expandImage.image
        
        
    }
    
    
    func doubleTappedOnView(sender:UITapGestureRecognizer){
        
        
        let expandedImage = self.view.viewWithTag(3) as! UIImageView
        
        expandedImage.image = nil
        expandedImage.isHidden = true
        
        
        
        
        
    }
    
    
    /* no use of this
    func didSetItemWith(_ state: Bool, itemType: String) {
        
        print("invoke first")
        
        
        
        
    }
    
    func didGetItemSucceedWithItem(_ itemType: String, item: NSDictionary?) {
        
        if itemType == c.TYPE_USER_FILE{
            
            print("Suppose not having this type appera")
            
        }
        else if itemType == c.TYPE_FILE{
            
            
            
            if item != nil{
                
                
                
                let file_course = item?.object(forKey: c.TAG_FILE_COURSE) as! String
                
                if file_course == self.courseName {
                    fileList.add(item)
                    fileListInThisCourse_name.append(file_course)
                    
                    print("============")
                    print(item?.object(forKey: c.TAG_FILE_COURSE))
                    
                }
                
                DispatchQueue.main.sync {
                    self.collectionView.reloadData()
                    
                }
            }
            
            
            
        }
        
        
    }
    func didGetItemFailedWithError(_ itemType: String, error: String) {
        
        
        print(error)
    }
    
    */
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

 
}
 
 
*/
