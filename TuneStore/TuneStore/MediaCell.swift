//
//  MediaCell.swift
//  TuneStore
//
//  Created by ben on 9/7/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class MediaCell : UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    var imageDownloadTask: NSURLSessionDownloadTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // TODO: clear old image / request
        
        artworkImageView.image = nil
        imageDownloadTask?.cancel()
    }
    
    func loadImageWithURL(url: NSURL) {
        // TODO: load image
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (let data, let response, let error) in
            
            if error == nil {
                let image = UIImage(data:data)
                dispatch_async(dispatch_get_main_queue()) {
                    self.artworkImageView.image = image
                }
            }
        }
        
        task.resume()
    }
}
