//
//  MovieDetailsViewController.swift
//  Flixster
//
//  Created by Kavita Gaitonde on 9/13/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailsScrollView: UIScrollView!
    
    @IBOutlet weak var titleLabelView: UILabel!
    
    @IBOutlet weak var detailsLabelView: UILabel!
    
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup movie info
    
        self.titleLabelView?.text = movie?["title"] as? String
        self.detailsLabelView?.text = movie?["overview"] as? String
        if let posterPath = movie?["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.MOVIE_POSTER_BASE_URL+posterPath)
            self.imageView.setImageWith(posterUrl! as URL)
        }
        self.detailsLabelView.sizeToFit()
        
        self.detailsScrollView.contentSize = CGSize(width: self.detailsScrollView.bounds.width, height: self.detailsScrollView.bounds.height * 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
