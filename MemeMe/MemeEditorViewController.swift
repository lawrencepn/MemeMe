//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/03/12.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var moveView:Bool = true

    var meme = MemeMe?()
    var previousView: String?
    
    let memeTextAtrributes:NSDictionary = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSStrokeWidthAttributeName : -2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        shareButton.enabled = false
        bottomText.delegate = self
        topText.delegate = self
        
        //set textfield defaults
        
        topText.defaultTextAttributes = memeTextAtrributes as! [String: AnyObject]
        bottomText.defaultTextAttributes = memeTextAtrributes as! [String : AnyObject]
        topText.textAlignment = NSTextAlignment.Center
        bottomText.textAlignment = NSTextAlignment.Center
        imageView.clipsToBounds = true
        
        //disable root tabbar
        tabBarController?.tabBar.hidden = true
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }
    

    @IBAction func imagePicker(sender: AnyObject) {
        imagePickerActionHandler("album")
    }

    @IBAction func cameraPicker(sender: AnyObject) {
        imagePickerActionHandler("camera")
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageView.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
        
        //enable save button
        
    }
    
    func imagePickerActionHandler(pickerType:String){
        
        let pickerSource = UIImagePickerController()
        pickerSource.delegate = self
        
        if(pickerType == "camera"){
            pickerSource.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(pickerSource, animated:true, completion:nil)
            
        }else{
            presentViewController(pickerSource, animated:true, completion:nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //*textfield delagate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {

       //half the screen
        let halfScreen = view.frame.height / 2
        let textFieldPosition = textField.frame.origin.y - halfScreen
        if(textFieldPosition < 0){
            moveView = false
        }else{
            moveView = true
        }
    }
    
    
    //subscribe to notifications
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //unSubscribe to notifications
    func unSubscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Adjust view when keyboard is shown
    func keyboardWillShow(notification:NSNotification){
        //only adjust for top text
        if(moveView){
            if(view.frame.origin.y == 0.0){
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        if(moveView){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardHeight = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardHeight.CGRectValue().height
    }
    
    
    //meme it
    func generateMemeMe() -> UIImage{
        
        //get image
        let image = imageView.image!
    
        //begin new CIG image context
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        
        //draw resized image
        let imageRec = CGRect(origin: CGPointZero, size: image.size)
        imageView.drawRect(imageRec)

        //draw in the text
        topText.drawTextInRect(CGRect(x: (imageView.frame.width - topText.frame.width) / 2, y:4.0, width: topText.frame.width, height: topText.frame.height))
        bottomText.drawTextInRect(CGRect(x: (imageView.frame.width - topText.frame.width) / 2, y:imageView.frame.height - topText.frame.height, width: topText.frame.width, height: topText.frame.height))
        
        let memeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return memeImage
        //return image5
        
    }
    
    
    //save meme to photo gallery
    func saveMemeToPhotoGallery(){
        //save to struct
        let memeMe = MemeMe(topText: topText.text!, bottomText: bottomText.text!, origialImage: imageView.image!, memedImage: generateMemeMe())
        
        //save to ablbums
        UIImageWriteToSavedPhotosAlbum(memeMe.memedImage, nil, nil, nil)
        
        //imagedata
        //let memeData : NSData = UIImagePNGRepresentation(memeMe.memedImage)!
        
        //save the meme to the MEME Array
        meme = memeMe
        
    }

    
    //share meme
    @IBAction func shareMeme(sender: AnyObject) {
        
        //meme to share
        let memeToShare = generateMemeMe()
        
        let shareController:UIActivityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        
        presentViewController(shareController, animated: true, completion: nil)
        
        shareController.completionWithItemsHandler = {
            
            (activity: String?, completed:Bool, items:[AnyObject]?, err:NSError?) -> Void in
            self.shareButton.enabled = true
            if(completed){
                self.saveMemeToPhotoGallery()
                self.performSegueWithIdentifier(self.previousView!, sender: self)
            }
            
        }
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        if (saveButton === sender){
            saveMemeToPhotoGallery()
        }
    }
    
}

