//
//  MediaSearchViewController.swift
//  TuneStore
//
//  Created by ben on 9/7/14.
//  Copyright (c) 2014 Fickle Bits. All rights reserved.
//

import UIKit

class MediaSearchViewController : UITableViewController, UISearchBarDelegate {
    
    lazy var config = NSURLSessionConfiguration.defaultSessionConfiguration()
    lazy var session: NSURLSession = {
        return NSURLSession(configuration: self.config)
    }()
    
    var results = [ NSDictionary ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func clearResults() {
        results = []
        tableView.reloadData()
    }
    
    func searchForTerm(term: String) {
        let encodedTerm = term.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = NSURL(string: "https://itunes.apple.com/search?country=US&term=\(encodedTerm!)")

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        // TODO: search for term

        let task = session.dataTaskWithURL(url) {
            (let data, let response, let error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.handleSearchResults(data)
        }
        
        task.resume()
    }
    
    func handleSearchResults(data: NSData) {
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
            results = map(json["results"] as NSArray) { $0 as NSDictionary }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let identifier = "mediaCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as MediaCell
        let record = results[indexPath.row]
        
        cell.nameLabel.text = record["artistName"] as? String
        cell.descriptionLabel.text = record["primaryGenreName"] as? String
        
        if let collection = record["collectionName"] as? String {
            cell.collectionNameLabel.text = collection
        } else {
            cell.collectionNameLabel.text = nil
        }
        
        let imageString = record["artworkUrl100"] as? String
        if imageString != nil {
            let imageUrl = NSURL(string: imageString!)
            cell.loadImageWithURL(imageUrl)
        }
        
        return cell
    }
    
    // mark - UISearchBarDelegate
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchForTerm(searchBar.text)
    }
}
