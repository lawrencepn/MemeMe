//
//  SharedMemesModel.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/05/17.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation

class SharedMemesModel:NSObject{
    
    var memesArray = [MemeMe]()
    
    func saveToMemesArray(meme: MemeMe){
        memesArray.append(meme)
    }
    
    func storedMemes() -> [MemeMe]{
        return memesArray
    }
    
    func storedMemesCount() -> Int{
        
     return memesArray.count
     
    }
    
}