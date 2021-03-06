//
//  TestBlankViewController.swift
//  UNote
//
//  Created by Paul Yeung on 19/11/2016.
//  Copyright © 2016 EE4304. All rights reserved.
//

import UIKit

class TestBlankViewController: UIViewController, UserUploadDownloadCallBackProtocol {

    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /********************************************/
        /********************************************/
        /*
                Note that the fileID is different 
                from file name!!!!
                the ID must be unique
                
                for ur use, please store the file's info like id, name, type, date....
                in FilesTable
         
                upload the file info with setFileInfo() function,
                upload the actual file with uploadFile() function
         */
        /********************************************/
        /********************************************/
        
        // upload code
//        let testimage = UIImage(named: "testImage.jpg")
//        let imagedata = UIImagePNGRepresentation(testimage!)!
//        Appdata.sharedInstance.awsEditor?.uploadFile(data: imagedata as NSData, fileid: "yoooooo")
        
        // download code
        Appdata.sharedInstance.awsEditor?.downloadFile(fileid: "public/heyheyhey")
        Appdata.sharedInstance.awsEditor?.fileManager = self
    }
    
    func didUploadFileSucceedWith(_ fileid:String){
        
    }
    func didUploadFileFailedWith(_ fileid:String, error:String){
        
    }
    
    func didDownloadFileSucceedWith(_ fileid:String, data:NSData) {
        let imagefromdata = UIImage(data: data as Data)
        DispatchQueue.main.async {
            self.imageview.image = imagefromdata
        }
    }
    
    func didDownloadFileFailedWith(_ fileid:String, error:String){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
