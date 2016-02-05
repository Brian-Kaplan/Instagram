//
//  PhotoDetailsViewController.swift
//  Instagram
//
//  Created by Brian Kaplan on 2/4/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    
    var feedEntry: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let imageURL = NSURL( string: self.feedEntry.valueForKeyPath("images.low_resolution.url") as! String)
        photoView.setImageWithURL(imageURL!)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
