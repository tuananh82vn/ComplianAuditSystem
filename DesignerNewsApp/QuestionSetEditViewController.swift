//
//  QuestionSetEditViewController.swift
//  DesignerNewsApp
//
//  Created by synotivemac on 13/08/2015.
//  Copyright (c) 2015 Synotive. All rights reserved.
//

import UIKit
import Photos




class QuestionSetEditViewController: UIViewController , SSRadioButtonControllerDelegate, UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    
    @IBOutlet weak var txt_Attachment: UITextField!
    @IBOutlet weak var img_Attachment: UIImageView!
    
    @IBOutlet weak var radio_Minor: SSRadioButton!
    @IBOutlet weak var radio_Major: SSRadioButton!
    @IBOutlet weak var radio_Critical: SSRadioButton!
    @IBOutlet weak var radio_Recomendation: SSRadioButton!
    @IBOutlet weak var radio_NotAudited: SSRadioButton!
    @IBOutlet weak var radio_NotApplicable: SSRadioButton!
    @IBOutlet weak var radio_Confirm: SSRadioButton!
    
    
    @IBOutlet weak var txt_Reponse: UITextView!
    @IBOutlet weak var lbl_Priority: UILabel!
    @IBOutlet weak var lbl_Number: UILabel!
    
    @IBOutlet weak var txt_Question: UITextView!
    
    var radioButtonController: SSRadioButtonsController?
    
    
    var QuestionId : Int = 0
    var QuestionRespone = QuestionResponseModel()
    
    
    var albumFound : Bool = false
    
    var assetCollection: PHAssetCollection!
    
    var photosAsset: PHFetchResult!
    
    var assetThumbnailSize:CGSize!
    
    var FileContentString : String = ""
    
    var bookingAttachment = BookingAttachment()
    
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        InitFolder()
        
        radioButtonController = SSRadioButtonsController(buttons: radio_Minor, radio_Major, radio_Critical,radio_Recomendation, radio_NotAudited , radio_NotApplicable, radio_Confirm)
        
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        
        InitData()
        
        // Do any additional setup after loading the view.
    }
    
    func InitData(){
        view.showLoading()
        
        WebApiService.getAuditActivityQuestionSetQuestionResponseSelect(LocalStore.accessToken()!, Id: QuestionId ) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                self.QuestionRespone = temp
                
                self.lbl_Number.text = "Q - " + self.QuestionRespone.SerialNumber.description
                
                self.txt_Question.text = self.QuestionRespone.Name
                
                self.lbl_Priority.text = self.QuestionRespone.Priority
                
                self.txt_Reponse.text = self.QuestionRespone.AuditResponse
                
                self.txt_Attachment.text = self.QuestionRespone.FileName
                
                if (self.QuestionRespone.ResponseCategoryId == 1) {
                    self.radio_NotApplicable.selected = true
                }
                else
                    if (self.QuestionRespone.ResponseCategoryId  == 2) {
                        self.radio_Confirm.selected = true
                    }
                    else
                        if (self.QuestionRespone.ResponseCategoryId  == 3) {
                            self.radio_Critical.selected = true
                        }
                        else
                            if (self.QuestionRespone.ResponseCategoryId  == 4) {
                                self.radio_Major.selected = true
                            }
                            else
                                if (self.QuestionRespone.ResponseCategoryId  == 5) {
                                    self.radio_Minor.selected = true
                            }
                                else
                                    if (self.QuestionRespone.ResponseCategoryId  == 6) {
                                        self.radio_NotAudited.selected = true
                                    }
                                    else
                                        if (self.QuestionRespone.ResponseCategoryId  == 7) {
                                            self.radio_Recomendation.selected = true
                                    }
                                        else{
                                            self.radio_Confirm.selected = true
                                        }
                

            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    @IBAction func ButtonPhotoClicked(sender: AnyObject) {
        var picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }

    @IBAction func ButtonSaveClicked(sender: AnyObject) {
        
        self.QuestionRespone.AuditResponse = self.txt_Reponse.text
        
        if self.radio_NotApplicable.selected {
            self.QuestionRespone.ResponseCategoryId = 1
        }
        else
            if self.radio_Confirm.selected {
                self.QuestionRespone.ResponseCategoryId = 2
        }
        else
                if self.radio_Critical.selected {
                    self.QuestionRespone.ResponseCategoryId = 3
        }
        else
                    if self.radio_Major.selected {
                        self.QuestionRespone.ResponseCategoryId = 4
        }
        else
                        if self.radio_Minor.selected {
                            self.QuestionRespone.ResponseCategoryId = 5
        }
        else
                            if self.radio_NotAudited.selected {
                                self.QuestionRespone.ResponseCategoryId = 6
        }
        else
                                if self.radio_Recomendation.selected {
                                    self.QuestionRespone.ResponseCategoryId = 7
        }

        self.QuestionRespone.Attachment = self.bookingAttachment
        
        
        WebApiService.postAuditActivityQuestionSetQuestionResponseEdit(LocalStore.accessToken()!, object: self.QuestionRespone) { objectReturn in
            
            if let temp = objectReturn {
                
                self.view.hideLoading()
                
                if(temp.IsSuccess){
                    
                    var temp = ["selectedIndex" : self.selectedIndex]
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("refeshQuestion", object: nil, userInfo: temp)
                    
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
    
    @IBAction func ButtonCancelClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
        
    }
    
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
        
        
        let asset: PHAsset = self.photosAsset.lastObject as! PHAsset
        
        self.assetThumbnailSize = CGSizeMake(CGFloat(asset.pixelHeight),CGFloat(asset.pixelWidth))
        
        //println(asset.creationDate.ToDateTimeString())
        
        if(asset.mediaType.rawValue == 1)
        {
            self.txt_Attachment.text = asset.creationDate.ToDateTimeString() + ".jpg"
            bookingAttachment.FileName = self.txt_Attachment.text
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
            
            self.img_Attachment.image = result
            
            if let temp = result {
                
                var imageData = UIImageJPEGRepresentation(temp, 1)
                if let imageNotNull = imageData {
                    let base64String = imageNotNull.base64EncodedStringWithOptions(.allZeros)
                    self.bookingAttachment.FileContent = base64String
                }
            }
        })
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

}
