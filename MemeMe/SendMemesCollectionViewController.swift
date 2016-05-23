//
//  SendMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/04/28.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation
import UIKit

class SendMemesCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    var selectedMeme = 0
    //var storedMemesArray = [MemeMe]()
    var memeModel = SharedMemesModel()
 
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowlayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //collectionView Flow layout sizing
        
        let space : CGFloat = 1.0
        let dimension = (view.frame.width - (2 * space)) / 3.0
        
        flowlayout.minimumInteritemSpacing = space
        flowlayout.itemSize = CGSizeMake(dimension, dimension)
        
        let barViewControllers = self.navigationController?.tabBarController?.viewControllers
        
        let svc = barViewControllers![1].childViewControllers[0] as! MemeTableViewController
        
        svc.memeModel = self.memeModel  //shared model
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //storedMemesArray = memeModel.storedMemes()
        collectionView.reloadData()
        //print(storedMemesArray.count)
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memeModel.storedMemesCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //deque
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GridCell", forIndexPath: indexPath)
        
        //then assign
        let image = memeModel.storedMemes()[indexPath.row].memedImage
        
        cell.backgroundView = UIImageView(image: image)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //pass the image to next view
        selectedMeme = indexPath.row
        performSegueWithIdentifier("FromGridToMemeView", sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let segueIdentifier = segue.identifier
        
        if(segueIdentifier == "FromGridToMemeView"){
            
            let storedMemeAtIndexView = segue.destinationViewController as! ViewStoredMemeController
        
            storedMemeAtIndexView.storedMemes = memeModel.storedMemes()[selectedMeme]
            
        }else if(segueIdentifier == "addFromGrid"){
            
            let addMemeViewController = segue.destinationViewController.childViewControllers.first as! MemeEditorViewController
            
            addMemeViewController.previousView = "unwindToGridView"
        }
        
    }
    
    @IBAction func unwindToGridView(sender: UIStoryboardSegue){
    
        if let sourceViewController = sender.sourceViewController as? MemeEditorViewController, meme = sourceViewController.meme{
            //a new meme to the array of memes
            let rowCount = memeModel.storedMemesCount()
            print(rowCount)
            let newIndex = NSIndexPath(forRow: rowCount, inSection: 0)
            //storedMemesArray.append(meme)
            memeModel.saveToMemesArray(meme)
            collectionView.insertItemsAtIndexPaths([newIndex])
        }
        
    }
    
}
