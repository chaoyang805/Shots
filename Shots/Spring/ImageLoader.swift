// The MIT License (MIT)
//
// Copyright (c) 2014 Nate Lyman (https://github.com/natelyman/SwiftImageLoader)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Foundation


public class ImageLoader {
    
    var cache = Cache<NSString, NSData>()
    
    public class var sharedLoader : ImageLoader {
    struct Static {
        static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    public func imageForUrl(_ urlString: String, completionHandler:(image: UIImage?, url: String) -> ()) {
        DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosBackground).async(execute: {()in
            let data = self.cache.object(forKey: urlString) as? Data
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                DispatchQueue.main.async(execute: {
                    completionHandler(image: image, url: urlString)
                })
               
                return
            }
            
            let downloadTask: URLSessionDataTask = URLSession.shared().dataTask(with: URL(string: urlString)!, completionHandler: { (url, response, error) in
                if error != nil {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    self.cache.setObject(data!, forKey: urlString)
                    DispatchQueue.main.async(execute: { 
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            
//            dataTaskWithURL(NSURL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
//                if (error != nil) {
//                    completionHandler(image: nil, url: urlString)
//                    return
//                }
//                
//                if data != nil {
//                    let image = UIImage(data: data!)
//                    self.cache.setObject(data!, forKey: urlString)
//                    dispatch_async(dispatch_get_main_queue(), {() in
//                        completionHandler(image: image, url: urlString)
//                    })
//                    return
//                }
//            })
            downloadTask.resume()
            
        })
        
    }
}
