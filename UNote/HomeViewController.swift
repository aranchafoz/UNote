//
//  HomeViewController.swift
//  UNote
//
//  Created by eda on 17/10/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//


import UIKit
import EventKit
import CoreData

class HomeViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate{
    
    
    var courseListCoreData : [CourseList] = []
    
    let coreDataStack = CourseListCore()
    var searchText : String!
    
    
    var courseList : [String] = []
    var refresher = UIRefreshControl()
    
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
    
    
    
    let editbtn = UIBarButtonItem()
    
    
    // data source
    private var numberOfFolders = 9
    
    private let leftAndRightPaddings: CGFloat = 0.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    //private let heightAdjustment: CGFloat = 30.0
    private var itemWidth: CGFloat = 200.0
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    
    func myRightSideBarButtonItemTapped(_ sender:UIBarButtonItem!)
    {
        print("myRightSideBarButtonItemTapped")
        
        
    }
    
    
    @IBAction func editButton(_ sender: AnyObject) {
        
        
    }
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
        self.searchText = searchBar.text
        
        
        updateText()
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = true
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    
    func updateText(){
        
        if let searchText = searchBar.text {
            
            courseList = searchText.isEmpty ? courseList : courseList.filter({
                (dataString: String) -> Bool in return (dataString.range(of: searchText) != nil)
            })
            
            
            print("dasda")
            
            self.collectionView.reloadData()
        }
        
        
    }
    
    // MARK: - View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.placeholder = "Search"
        
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.searchBar.delegate = self
        
        
        
        
        let context = coreDataStack.persistentContainer.viewContext
        
        
        do{
            courseListCoreData = try context.fetch(CourseList.fetchRequest())
            
            
            if courseListCoreData.count > 0{
                
                for course in courseListCoreData{
                    courseList.append(course.courseTitle!)
                    
                    print("my record:" ,courseList)
                }
                
                
            }else{
                
                print("found no record")
                
                
                
            }
            
        }catch{
            
            
        }
        
        refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView!.addSubview(refresher)
        
        
        
        
        
        // Do any additional setup after loading the view.
        //let layout = collectionView.collectionViewLayout
        //layout.
        //let layout = collectionView as! UICollectionViewFlowLayout
        //layout.itemSize = CGSize(width: width,height: width + heightAdjustment)
        
        
        
        
        
        
    }
    
    func loadData()
    {
        //code to execute during refresher
        
        
        
        let context = coreDataStack.persistentContainer.viewContext
        
        courseList.removeAll()
        
        
        do{
            courseListCoreData = try context.fetch(CourseList.fetchRequest())
            
            
            if courseListCoreData.count > 0{
                
                for course in courseListCoreData{
                    courseList.append(course.courseTitle!)
                    
                    print("my record:" ,courseList)
                }
                
                
            }else{
                
                print("found no record")
                
                
                
            }
            
        }catch{
            
            
        }
        
        
        self.collectionView.reloadData()
        
        stopRefresher()         //Call this to stop refresher
    }
    
    func stopRefresher()
    {
        //
        
        refresher.endRefreshing()
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return numberOfFolders
        
        return courseList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let folderCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath) as UICollectionViewCell
        
        // Set File image
        let img = folderCell.contentView.viewWithTag(1) as! UIImageView
        img.image = UIImage(named: "Folder")
        
        // Set Subject name
        let value = folderCell.contentView.viewWithTag(2) as! UILabel
        
        
        //value.text = "EE4304"
        value.text = courseList[indexPath.item]
        
        let LeftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.removeItem(sender:)))
        
        LeftSwipe.direction = UISwipeGestureRecognizerDirection.left
        
        folderCell.addGestureRecognizer(LeftSwipe)
        
        return folderCell
    }
    
    
    func removeItem(sender: UISwipeGestureRecognizer){
        
        let alert = UIAlertController(title: "Do you want to delete this folder?", message: "Swipe to left will remove item", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                
                let cell = sender.view as! UICollectionViewCell
                
                let ip = self.collectionView.indexPath(for: cell)?.item
                
                self.courseList.remove(at: ip!)
                
                self.removeItemAtCoreData(index: ip!)
                
                self.collectionView.reloadData()
                
                print("destructive")
            }
        }))
        
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    private func removeItemAtCoreData(index : Int){
        
        let context = self.coreDataStack.persistentContainer.viewContext
        
        
        do{
            
            courseListCoreData = try context.fetch(CourseList.fetchRequest())
            
            context.delete(courseListCoreData[index])
            
            coreDataStack.saveContext()
            
            
        }catch{
            
            print("error")
        }
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell : UICollectionViewCell = collectionView.cellForItem(at: indexPath){
            
            cell.backgroundColor = UIColor.magenta
            
            let passValStand = UserDefaults.standard
            
            let valLabel = cell.contentView.viewWithTag(2) as! UILabel!
            
            if let setVal = valLabel {
                
                passValStand.set(setVal.text, forKey: "SaveCourseNameInDetailController")
                
                passValStand.synchronize()
                
            }
        }
        
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
        
        
        print("ready to segue")
        
        
        
    }
    
    
    
    
}
