//
//  ViewController.swift
//  DownloadImageDemo
//
//  Created by ben on 9/7/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSURLSessionDownloadDelegate {
                            
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.progress = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func downloadTapped(sender: AnyObject) {
        imageView.image = nil
        let imageUrl = NSURL(string: "http://farm4.staticflickr.com/3702/10279837556_455bf832f1_o.jpg")
        
        // TODO: download image here
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
     
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = session.downloadTaskWithURL(imageUrl)
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!,
        didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64) {
            dispatch_async(dispatch_get_main_queue()) {
                let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
                self.progressView.progress = progress
            }
    }
    
    func URLSession(session: NSURLSession!, downloadTask: NSURLSessionDownloadTask!,
        didFinishDownloadingToURL location: NSURL!) {
            if let http = downloadTask.response as? NSHTTPURLResponse {
                if http.statusCode == 200 {
                    let imageData = NSData(contentsOfURL: location)
                    let image = UIImage(data: imageData)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imageView.image = image
                    }
                    
                } else {
                    println("Got an HTTP \(http.statusCode)")
                }
            } else {
                println("Invalid response")
            }
    }
    
    func URLSession(session: NSURLSession!, task: NSURLSessionTask!,
        didCompleteWithError error: NSError!) {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
            if error != nil {
                println("Got an error: \(error)")
            }
    }
}

