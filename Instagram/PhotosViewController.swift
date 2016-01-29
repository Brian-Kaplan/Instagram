//
//  PhotosViewController.swift
//  Instagram
//
//  Created by Brian Kaplan on 1/28/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var feed: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
                       self.feed = responseDictionary["data"] as? [NSDictionary]
                       self.tableView.reloadData()
                    }
                }
                else{
                    NSLog("bad request")
                }
        });
        task.resume()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
