//
//  MemeMeStruct.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/03/12.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation
import UIKit

struct MemeMe {
    let topText:String
    let bottomText:String
    let origialImage:UIImage
    let memedImage:UIImage
    
    init(topText:String, bottomText:String,origialImage:UIImage, memedImage:UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.origialImage = origialImage
        self.memedImage = memedImage
    }
}