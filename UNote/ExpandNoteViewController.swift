//
//  ExpandNoteViewController.swift
//  UNote
//
//  Created by Arancha Ferrero Ortiz de Zárate on 21/11/16.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class ExpandNoteViewController: UIViewController {
    
    @IBOutlet weak var expandImage: UIImageView!
    
    var userID : String!
    var courseName : String!
    var filesSaved:[NSDictionary] = []
    var selectedImage:UIImage!
    var dataSourceForSearchResult:[NSDictionary] = []
    var imageDataSetDict:NSMutableDictionary = [:]
    
    var toPass:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        expandImage.image = toPass
        
        
        userID = UserDefaults.standard.value(forKey: "userID") as! String!
        courseName = UserDefaults.standard.value(forKey: "course") as! String!
        
        
        filesSaved = UserDefaults.standard.value(forKey: "savedMaterial") as! [NSDictionary]
        
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(sender:)))
        
        
        view.addGestureRecognizer(longPressRecognizer)
        
        
        Appdata.sharedInstance.awsEditor?.getUserFilesListTable(self.userID)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    func didUploadFileSucceedWith(_ fileid: String) {
        
    }
    
    func didDownloadFileFailedWith(_ fileid: String, error: String) {
        
        
        print("wwwwwww")
    }
    
    
    func didDownloadFileSucceedWith(_ fileid: String, data: NSData) {
        
        print("ssssss")
        
        print(fileid)
        imageDataSetDict[fileid] = data
        
        
        
    }
    func didUploadFileFailedWith(_ fileid: String, error: String) {
        
        
        
    }
    
    
    func longPressed(sender:UILongPressGestureRecognizer){
        
        
        let passImageToSave = self.expandImage.image
        
        if sender.state == UIGestureRecognizerState.ended{
            print("okok")
            if passImageToSave != nil {
                
                
                UIImageWriteToSavedPhotosAlbum(self.expandImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            
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
            print("okooooo")
        }
    }

}
