//
//  SendMemesTableViewController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/04/28.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation
import UIKit

class SendMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var selectedMeme = 0
    var memes = [MemeMe]()
    var memeModel = SharedMemesModel()
    let cellIdentifer = "MemeTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memes = memeModel.storedMemes()
        
        //update
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storedMemeAtIndexViewController = storyboard?.instantiateViewControllerWithIdentifier("ViewStoredMemeController") as! ViewStoredMemeController
        storedMemeAtIndexViewController.storedMemes = memes[indexPath.row]
        navigationController?.pushViewController(storedMemeAtIndexViewController, animated: true)
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as! MemeTableViewCell
        
        cell.memeImage?.image = memes[indexPath.row].memedImage
        
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