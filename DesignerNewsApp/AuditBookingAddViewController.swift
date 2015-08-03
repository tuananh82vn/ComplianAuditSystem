//
//  AuditBookingAddViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 3/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Photos

let reuseIdentifier = "PhotoCell"
let albumName = "App Folder"

class AuditBookingAddViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
    var albumFound : Bool = false
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!
    
    var assetThumbnailSize:CGSize!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        InitFolder()
    
    }
    
    func InitFolder(){
        //Check if the folder exists, if not, create it
        
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let first_Obj:AnyObject = collection.firstObject
        {
            //found the album
            self.albumFound = true
            self.assetCollection = first_Obj as! PHAssetCollection
        }
        else
        {
            //Album placeholder for the asset collection, used to reference collection in completion handler
            var albumPlaceholder:PHObjectPlaceholder!
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let request = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                albumPlaceholder = request.placeholderForCreatedAssetCollection
                },
                completionHandler: {(success:Bool, error:NSError!)in
                    if(success)
                    {
                        self.albumFound = true
                        if let collection = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([albumPlaceholder.localIdentifier], options: nil){
                            self.assetCollection = collection.firstObject as! PHAssetCollection
                        }
                    }
                    else
                    {
                        self.albumFound = false
                    }
            })
        }
        
        //println("Co tat ca :"+self.photosAsset.count.description)
        
    }

    @IBOutlet weak var img_Thumbnail: UIImageView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ButtonGalaryClicked(sender: AnyObject) {
        
        
        var picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func ButtonCameraClicked(sender: AnyObject) {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            
            //load the camera interface
            var picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            //no camera available
            var alert = UIAlertController(title: "Error", message: "There is no camera available", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {(alertAction)in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }

    }

    @IBOutlet weak var ButtonCancelClicked: UIButton!

    @IBOutlet weak var ButtonSaveClicked: UIButton!
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        if let image: UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            //Implement if allowing user to edit the selected image
            //let editedImage = info.objectForKey("UIImagePickerControllerEditedImage") as UIImage
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), {
                
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                    
                        let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                    
                        let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                    
                        if let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection, assets: self.photosAsset) {
                            
                            albumChangeRequest.addAssets([assetPlaceholder])
                        }
                    
                    }, completionHandler: {(success, error)in
                        dispatch_async(dispatch_get_main_queue(), {

                            picker.dismissViewControllerAnimated(true, completion: nil)
                            
                            self.photosAsset = PHAsset.fetchAssetsInAssetCollection(self.assetCollection, options: nil)

                            self.DisplayImage()

                        })
                })
                
            })
        }
    }
    
    func DisplayImage() {
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        let imageOptions = PHImageRequestOptions()
        
        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast

        self.assetThumbnailSize = CGSizeMake(100,100)
        
        let asset: PHAsset = self.photosAsset.lastObject as! PHAsset
        
        println(asset.creationDate.ToDateTimeString())
        
        //println(asset.mediaType)

        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.assetThumbnailSize, contentMode: .AspectFill, options: imageOptions, resultHandler: {(result, info)in
            
            self.img_Thumbnail.image = result
            
            if let temp = result {
            
                var imageData = UIImageJPEGRepresentation(temp, 0)
                if let imageNotNull = imageData {
                    let base64String = imageNotNull.base64EncodedStringWithOptions(.allZeros)
                    println(base64String)
                }
            }
            
        })
    
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
