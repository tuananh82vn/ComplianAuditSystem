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

let albumName = "Compliance Audit System Folder"

class AuditBookingAddViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var txt_FileName: UITextField!
    @IBOutlet weak var txt_Notes: UITextView!

    
    @IBOutlet weak var txt_Item: UITextView!
    
    var albumFound : Bool = false
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!
    
    var assetThumbnailSize:CGSize!
    
    var FileContentString : String = ""
    
    var bookingAttachment = BookingAttachment()
    
    var uploadBookingItem = AuditActivityBookingDetaiModel()
    
    var AddMode : Bool = false
    
    var selectedBookingId : Int = 0
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        InitFolder()
        
        if(AddMode)
        {
            self.lbl_Title.text = "Add Booking Detail"
            
        }
        else
        {
            self.lbl_Title.text = "Edit Booking Detail"
            
            InitData()
        }
    }
    
    
    func InitData(){
        
        WebApiService.getAuditActivityBookingDetail(LocalStore.accessToken()!, Id: selectedBookingId) { objectReturn in
            
            if let temp = objectReturn {
                
                self.uploadBookingItem = temp
                
                self.txt_FileName.text = self.uploadBookingItem.DisplayFileName
                self.txt_Item.text = self.uploadBookingItem.Item
                self.txt_Notes.text = self.uploadBookingItem.Notes

            }
        }
   
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
            alert.view.tintColor = UIColor.blackColor()
            
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
        
        view.showLoading()
        
        // Create options for retrieving image (Degrades quality if using .Fast)
        let imageOptions = PHImageRequestOptions()
        
        imageOptions.resizeMode = PHImageRequestOptionsResizeMode.Fast


            
            let asset: PHAsset = self.photosAsset.lastObject as! PHAsset
            
            self.assetThumbnailSize = CGSizeMake(CGFloat(asset.pixelHeight),CGFloat(asset.pixelWidth))
            
            //println(asset.creationDate.ToDateTimeString())
            
            if(asset.mediaType.rawValue == 1)
            {
                self.txt_FileName.text = asset.creationDate.ToDateTimeString() + ".jpg"
                bookingAttachment.FileName = self.txt_FileName.text
                bookingAttachment.ContentType = "Image/jpeg"
                
            }
            
            
            PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil) { (data:NSData!, string:String!, orientation:UIImageOrientation, object:[NSObject : AnyObject]!) -> Void in
                //transform into image
                var image = UIImage(data: data)
                
                //Get bytes size of image
                var imageSize = Float(data.length)
                
                self.bookingAttachment.Size = imageSize
                
            }
            
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.assetThumbnailSize, contentMode: .AspectFill, options: imageOptions, resultHandler: {(result, info)in
                
                self.img_Thumbnail.image = result
                
                if let temp = result {
                    
                    var imageData = UIImageJPEGRepresentation(temp, 0.5)
                    if let imageNotNull = imageData {
                        let base64String = imageNotNull.base64EncodedStringWithOptions(.allZeros)
                        self.bookingAttachment.FileContent = base64String
                        
                        self.view.hideLoading()
                    }
                }
            })

    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func ButtonCancelClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        self.view.showLoading()
        
        self.uploadBookingItem.AuditActivityUrlId = LocalStore.accessAuditActivityUrlId()!
        self.uploadBookingItem.Item = self.txt_Item.text
        self.uploadBookingItem.Notes = self.txt_Notes.text
        self.uploadBookingItem.Attachment = self.bookingAttachment
        
        WebApiService.postAuditActivityBookingDetail(LocalStore.accessToken()!, bookingItem: self.uploadBookingItem, Type : AddMode) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){
                    

                    NSNotificationCenter.defaultCenter().postNotificationName("refeshBooking", object: nil)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else
                {
                    var errorMessage : String = ""
                    
                    for var index = 0; index < temp.Errors.count; ++index {
                        
                        errorMessage += temp.Errors[index].ErrorMessage
                    }
                    
                    
                    let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    alertController.view.tintColor = UIColor.blackColor()
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
}
