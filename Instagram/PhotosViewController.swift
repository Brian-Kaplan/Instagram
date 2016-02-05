//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Brian Kaplan on 1/28/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var feed: [NSDictionary]?
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        tableView.dataSource = self
        tableView.delegate = self
        
        networkRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = feed {
            return feed.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedCell
        let imageURL = NSURL( string: self.feed![indexPath.row].valueForKeyPath("images.low_resolution.url") as! String)
        let profilePicURL = NSURL( string: self.feed![indexPath.row].valueForKeyPath("user.profile_picture") as! String)
        let username = self.feed![indexPath.row].valueForKeyPath("user.username") as! String
        
        cell.cellPicture.setImageWithURL(imageURL!)
        cell.cellProfilePicture.setImageWithURL(profilePicURL!)
        cell.cellUsername.text = username
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // ... Code to load more results ...
                networkRequest()
            }
        }
    }
    
    func networkRequest(){
        // Do any additional setup after loading the view.
        let clientId = "e05c462ebd86446ea48a5af73769b602"
        let url = NSURL(string:"https://api.instagram.com/v1/media/popular?client_id=\(clientId)")
        
        // ... Create the NSURLRequest (myRequest) ...
        let request = NSURLRequest(URL: url!)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        //Do a network request
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            let data = responseDictionary["data"] as? [NSDictionary]
                            if self.feed == nil {
                                self.feed = data
                            }
                            else {
                                for item in data! {
                                    self.feed?.append(item)
                                }
                            }
                            self.tableView.reloadData()
                            self.isMoreDataLoading = false
                            // Stop the loading indicator
                            self.loadingMoreView!.stopAnimating()
//                            let rowToSelect = NSIndexPath(forRow: 0, inSection: 0)
//                            self.tableView.scrollToRowAtIndexPath(rowToSelect, atScrollPosition: .Top, animated: false)
                        
                            
                    }
                }
                else{
                    NSLog("bad request")
                }
        });
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(refreshControl: UIRefreshControl) {
        networkRequest()
        refreshControl.endRefreshing()
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! PhotoDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
        vc.feedEntry = feed![indexPath!.row]
        
    }
}







