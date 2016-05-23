//
//  ViewStoredMemeController.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/05/13.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation
import UIKit

class ViewStoredMemeController:  UIViewController, UINavigationControllerDelegate{
    
    var storedMemes:MemeMe!
    
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide tab bar
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        print(storedMemes)
        
        memeView.image = storedMemes.memedImage
        
    }
    
    @IBAction func backToHistoryView(sender: AnyObject) {
        
        //let controller = self.navigationController?.viewControllers[0]
        
        navigationController?.popViewControllerAnimated(true)
        
    }
}