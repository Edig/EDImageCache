//
//  EDCacheImages.swift
//  Tutton
//
//  Created by Eduardo Iglesias on 8/14/15.
//  Copyright (c) 2015. All rights reserved.
//

import UIKit
import ImageIO

let _sharedCache: EDCacheImages = { EDCacheImages() }()

class EDCacheImages: NSObject {
    
    var cachedImages = NSCache()
    
    class func sharedCache() -> EDCacheImages {
        NSNotificationCenter.defaultCenter().addObserver(_sharedCache, selector: "memoryWarning", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        return _sharedCache
    }
    
    func memoryWarning() {
        print("Memory Warning: !! Removing RAM cache")
        self.cachedImages.removeAllObjects()
    }
    
    //Get image async form URL
    //In this function we will check if we have cached the image or we need to download it
    //Call back with image, if callback doesn't exist, image will cache on RAM and Disk
    func getImageFromURL(url: NSURL, withCompletionHandler completionHandler:((image: UIImage, url: NSURL) -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            //Check if cached images exist
            if let image = self.getCacheImageForName(url.absoluteString) {
                
                //Image exist
                dispatch_async(dispatch_get_main_queue()) {
                    if let completion = completionHandler {
                        completion(image: image, url: url)
                    }
                }
                
                
            }else{
                //Image doesn't existe we need to download it
                if let image = self.asyncDownloadImageFromURL(url) {
                    //Image successfully downloaded
                    dispatch_async(dispatch_get_main_queue()) {
                        if let completion = completionHandler {
                            completion(image: image, url: url)
                        }
                    }
                }
            }
        }
    }
    
    private func asyncDownloadImageFromURL(url: NSURL) -> UIImage? {
        //        print("Downloading image \(url.absoluteString!.md5)")
        if let data = NSData(contentsOfURL: url) {
            
            //Now we cache the image on the disk and RAM
            
            if let imageRef = CGImageSourceCreateWithData(data as CFDataRef, nil) {
                if let imageSource = CGImageSourceCreateImageAtIndex(imageRef, 0, nil) {
                    
                    let img = UIImage(CGImage: imageSource)
                    cacheImage(img, withName: url.absoluteString)
                    
                    return img
                }
            }
        }
        
        return nil
    }
    
    
    // MARK: Cache images
    private func cacheImage(image:UIImage, withName name:String) {
        cacheImageOnRAM(image, withName: name)
        cacheImageOnDisk(image, withName: name)
    }
    
    private func cacheImageOnRAM(image:UIImage, withName name:String) {
        //Cache image on RAM
        //        print("saving cached image - RAM \(name.md5)")
        cachedImages.setObject(image, forKey: name.md5)
    }
    
    private func cacheImageOnDisk(image:UIImage, withName name:String) {
        //Cache image on disk
        
        //        print("saving cached image - DISK \(name.md5)")
        let path = "\(NSTemporaryDirectory())\(name.md5).png"
        if let imageRepresentation = UIImagePNGRepresentation(image) {
            imageRepresentation.writeToFile(path, atomically: true)
        }
    }
    
    // MARK: Get cached images
    private func getCacheImageForName(name:String) -> UIImage? {
        //Check if image is cached on RAM
        if let img = cachedImages.objectForKey(name.md5) as? UIImage {
            //            print("getting cached image RAM \(name.md5)")
            return img
        }
        
        let path = "\(NSTemporaryDirectory())\(name.md5).png"
        if let imageData = NSData(contentsOfFile: path) {
            if let imageRef = CGImageSourceCreateWithData(imageData, nil) {
                if let imageSource = CGImageSourceCreateImageAtIndex(imageRef, 0, nil) {
                    
                    return UIImage(CGImage: imageSource)
                }
            }
        }
        
        return nil
    }
    
    // MARK: Remove Cached Images
    func removeCacheImageOnRamForName(name: String) {
        cachedImages.removeObjectForKey(name.md5)
    }
    
}
