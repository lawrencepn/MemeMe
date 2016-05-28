//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/05/21.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var selectedMeme = 0
    var memes = [MemeMe]()
    var memeModel = SharedMemesModel()
    let cellIdentifer = "MemeTableViewCell"
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = memeModel.storedMemes()
        mainTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storedMemeAtIndexViewController = storyboard?.instantiateViewControllerWithIdentifier("ViewStoredMemeController") as! ViewStoredMemeController
        storedMemeAtIndexViewController.storedMemes = memes[indexPath.row]
        navigationController?.pushViewController(storedMemeAtIndexViewController, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath)
        
        
        
        let image = memeModel.storedMemes()[indexPath.row].memedImage
        
        let cellImg : UIImageView = UIImageView(frame: CGRectMake(0, 0, 90, 90))
        cellImg.contentMode = UIViewContentMode.ScaleAspectFit
        cellImg.image = image
        cell.addSubview(cellImg)
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let segueIdentifier = segue.identifier
        
        if(segueIdentifier == "FromTableToMemeView"){
            
            let storedMemeAtIndexView = segue.destinationViewController as! ViewStoredMemeController
            
            storedMemeAtIndexView.storedMemes = memes[selectedMeme]
        }else if(segueIdentifier == "addFromTable"){
            
            let addMemeViewController = segue.destinationViewController.childViewControllers.first as! MemeEditorViewController
            
            addMemeViewController.previousView = "unwindToTableView"
        }
        
        
    }
    
    @IBAction func unwindToTableView(sender: UIStoryboardSegue){
        
        if let sourceViewController = sender.sourceViewController as? MemeEditorViewController, meme = sourceViewController.meme{
            //a new meme to the array of memes
            
            let newIndex = NSIndexPath(forRow: memes.count, inSection: 0)
            
            memes.append(meme)
            memeModel.saveToMemesArray(meme)
            tableView.insertRowsAtIndexPaths([newIndex], withRowAnimation: .Bottom)
            
        }
        
    }

}
