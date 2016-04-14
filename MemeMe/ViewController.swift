//
//  ViewController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/03/12.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    var moveView:Bool = true
    
    let memeTextAtrributes:NSDictionary = [
        NSForegroundColorAttributeName : UIColor(white: 1.0, alpha: 1.0),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSStrokeColorAttributeName : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func imagePicker(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func cameraPicker(sender: AnyObject) {
        
        //open view controller and select image
        let cameraPhoto = UIImagePickerController()
        cameraPhoto.sourceType = UIImagePickerControllerSourceType.Camera
        cameraPhoto.delegate = self
        self.presentViewController(cameraPhoto, animated: true, completion: nil)
    }
    
    //DELEGATES
    
    //*Image picker delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageView.image = squareImage(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    
        //zoom to crop image
        
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
        let halfScreen = self.view.frame.height / 2
        let textFieldPosition = textField.frame.origin.y - halfScreen
        if(textFieldPosition < 0){
            moveView = false
        }else{
            moveView = true
        }
        
        
    }
    
    
    //subscribe to notifications
    
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
            if(self.view.frame.origin.y == 0.0){
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        if(moveView){
            self.view.frame.origin.y += getKeyboardHeight(notification)
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
    
    func squareImage(image: UIImage) -> UIImage{
        
        //REF:http://code-tuts.net/crop-image-to-square/
        //REF:http://nshipster.com/image-resizing/
        
        let cgiImage = image.CGImage!
        let imageSize = image.size
        //landscapre
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        // Check to see which length is the longest and create the offset based on that length, then set the width and height of our rect
        if imageSize.width > imageSize.height {
            posX = ((imageSize.width - imageSize.height) / 2)
            posY = 0
            width = imageSize.height
            height = imageSize.height
        } else {
            posX = 0
            posY = ((imageSize.height - imageSize.width) / 2)
            width = imageSize.width
            height = imageSize.width
        }
        
        //potrait or already square
        
        //CIG image context
        let cropRec = CGRect(x: posX, y: posY, width: width, height: height)
        
        let cgiImageRef = CGImageCreateWithImageInRect(cgiImage, cropRec)!
        let croppedImage = UIImage(CGImage: cgiImageRef, scale: image.scale, orientation: image.imageOrientation)
        return croppedImage
        
    }
    
    //save
    
    func save(){
        
        //save to struct
        let memeMe = MemeMe(topText: topText.text!, bottomText: bottomText.text!, origialImage: imageView.image!, memedImage: generateMemeMe())
        
        //save to ablbums
        UIImageWriteToSavedPhotosAlbum(memeMe.memedImage, nil, nil, nil)
    }
    
    //share meme
    @IBAction func shareMeme(sender: AnyObject) {
        
        //meme to share
        let memeToShare = generateMemeMe()
        
        let shareController:UIActivityViewController = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        
        self.presentViewController(shareController, animated: true, completion: nil)
        
        shareController.completionWithItemsHandler = {
            
            (activity: String?, completed:Bool, items:[AnyObject]?, err:NSError?) -> Void in
            self.shareButton.enabled = true
            if(completed){
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }
        
        
        
    }
   
}

