//
//  EDCacheImages.swift
//  Tutton
//
//  Created by Eduardo Iglesias on 8/14/15.
//  Copyright (c) 2015 CreApps. All rights reserved.
//

import UIKit

let _sharedCache: EDCacheImages = { EDCacheImages() }()

class EDCacheImages: NSObject {
    
    var cachedImages = NSCache()
    
    class func sharedCache() -> EDCacheImages {
        NSNotificationCenter.defaultCenter().addObserver(_sharedCache, selector: "memoryWarning", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
        return _sharedCache
    }
    
    func memoryWarning() {
        println("Removing RAM cache")
        self.cachedImages.removeAllObjects()
    }
    
    //Get image async form URL
    //In this function we will check if we have cached the image or we need to download it
    //Call back with image, if callback doesn't exist, image will cache on RAM and Disk
    func getImageFromURL(url: NSURL, withCompletionHandler completionHandler:((image: UIImage, url: NSURL) -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            //Check if cached images exist
            if let image = self.getCacheImageForName(url.absoluteString!) {
                
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
        println("Downloading image \(url.absoluteString!.md5)")
        if let data = NSData(contentsOfURL: url) {
            if let img = UIImage(data: data) {
                //We cache the image in RAM nad Disk
                cacheImage(img, withName: url.absoluteString!)
                return img
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
        println("saving cached image - RAM \(name.md5)")
        cachedImages.setObject(image, forKey: name.md5)
    }
    
    private func cacheImageOnDisk(image:UIImage, withName name:String) {
        //Cache image on disk
        println("saving cached image - DISK \(name.md5)")
        let data = UIImagePNGRepresentation(image)
        let fileManager = NSFileManager.defaultManager()
        let path = "\(NSTemporaryDirectory())\(name.md5).png"
        fileManager.createFileAtPath(path, contents: data, attributes: nil)
    }
    
    // MARK: Get cached images
    private func getCacheImageForName(name:String) -> UIImage? {
        //Check if image is cached on RAM
        if let img = cachedImages.objectForKey(name.md5) as? UIImage {
            println("getting cached image RAM \(name.md5)")
            return img
        }
        
        //Check if is cached in DISK
        let path = "\(NSTemporaryDirectory())\(name.md5).png"
        if let img = UIImage(contentsOfFile: path) {
            //Cache image on RAM
            println("getting cached image DISK \(name.md5)")
            cacheImageOnRAM(img, withName: name)
            return img
        }
        
        return nil
    }
    
    // MARK: Remove Cached Images
    func removeCacheImageOnRamForName(name: String) {
        cachedImages.removeObjectForKey(name.md5)
    }

}
