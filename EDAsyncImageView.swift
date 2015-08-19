
//
//  UIImageView+Extension.swift
//  Tutton
//
//  Created by Eduardo Iglesias on 6/9/15.
//  Copyright (c) 2015 CreApps. All rights reserved.
//

import UIKit

class EDAsyncImageView: UIImageView {
    
    var imageURL: NSURL! {
        didSet {
            if let old = oldValue {
                self.cleanImageViewWithURL(old, cleanCache: false)
            }
            self.downloadAsyncronousImage()
        }
    }
    
    func downloadAsyncronousImage() {
        EDCacheImages.sharedCache().getImageFromURL(self.imageURL) {
            image, url in
            
            if self.imageURL == url {
                self.image = image
            }
        }
    }
    
    func cleanImageViewWithURL(url: NSURL, cleanCache: Bool = true) {
        self.image = nil
        if cleanCache {
            EDCacheImages.sharedCache().removeCacheImageOnRamForName(url.absoluteString!)
        }
    }
    
    
    func downloadAsyncronousImageFrom(#url: NSURL, withCompletionHandler completionHandler:(() -> Void)? = nil) {
        self.imageURL = url
        EDCacheImages.sharedCache().getImageFromURL(self.imageURL) {
            image, url in
            if self.imageURL == url {
                self.image = image
                
                if let completion = completionHandler {
                    completion()
                }
            }
        }
    }
    
//    private func downloadImage(url: NSURL) {
//        if let data = NSData(contentsOfURL: url) {
//            if let img = UIImage(data: data) {
//                dispatch_async(dispatch_get_main_queue()) {
//                    if let imgURL = self.imageURL {
//                        if url ==  imgURL {
//                            //Save image on cahce
//                            
//                            self.image = img
//                        }
//                    }
//                }
//            }
//        }
//    }
}

