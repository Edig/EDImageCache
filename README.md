# EDImageCache
Simple Image cache in Swift (Supports iOS 8 & 9)

EDImageCache get download images and manage the cache, in saves it on the Hard Drive and RAM if the app is in use. 
It automatically clean RAM when the system needs it. 

How to implement it:

Pods:

1-. Install the pod:
````
pod 'EDImageCache' 
````
2-. Add extra frameworks:
Manually add ````CommonCrypto```` obj-c framework to your bridge-header

Manual:
- Copy all 3 files to your project
- Add ````UIKit````, ````ImageIO```` and ````CommonCrypto````

Note: ````CommonCrypto```` is a obj-c framework. You need a bridge-header 

Implement it:
You have to ways to control it.

First one using EDAsyncImageView, its automatically, just tell which image to download and it caches it
1-. Every imageView you want to be controlled by this shared cache you should add the class to EDAsyncImageView
2-. Just set ```imageURL``` with a ```NSURL``` and it will download, save and display the image automatically.

The second one is without using EDAsyncImageView, and using only EDCacheImages, you need to retrive and save the images manually.
This only explains the use of the Cache as is implemented in EDAsyncImageView
1-. This is a shared cache so to aces you need to get like this: ```EDCacheImages.sharedCache()```

To get the image from cache, if not founded it will downloaded

2-.

```swift
getImageFromURL(url: NSURL, withCompletionHandler completionHandler:((image: UIImage, url: NSURL) -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        ```

3-. If you want to remove an specific image from RAM you need to clean it like this

```swift
removeCacheImageOnRamForName(name: String)
```

Usually the name is the URL

# Todo:
- [ ] Auto clean Disk Cache after time 
- [ ] Queue requests, really helpful if you implement this on a tableView and do a long scroll
- [ ] Prioritize requests, give prirority to handle important request first
- [ ] Limiting thread, maximum the cores of the phones minus the UI thread
- [ ] Cancel requests, if you doesn't need an image anymore be able to cancel a request or give it less priority

Any ideas or suggestions open a issue,