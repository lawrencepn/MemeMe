//
//  SquareImageClass.swift
//  MemeMe
//
//  Created by Lawrence Nyakiso on 2016/04/15.
//  Copyright © 2016 KisoCloud. All rights reserved.
//

import Foundation
import UIKit

class SquareImageClass {
    
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
}