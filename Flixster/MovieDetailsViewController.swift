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
    
    @IBOutlet weak var detailView: UIView!
    var movie: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //setup movie info
    
        self.titleLabelView?.text = movie?["title"] as? String
        //self.titleLabelView?.sizeToFit()
        self.detailsLabelView?.text = movie?["overview"] as? String
        self.detailsLabelView?.sizeToFit()
        
        self.detailsScrollView.contentSize = CGSize(width: self.detailsScrollView.bounds.width, height: self.detailsScrollView.bounds.height + 50)
        
        self.setPosterImage()
    }

    func setPosterImage() {
        /*if let posterPath = movie?["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.MOVIE_POSTER_BASE_URL+posterPath)
            
            let imageRequest = NSURLRequest(url: posterUrl! as URL) as URLRequest
            
            self.imageView.setImageWith(
                imageRequest as URLRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.imageView.alpha = 0.0
                        self.imageView.image = image
                        UIView.animate(withDuration: 0.5, animations: { () -> Void in
                            self.imageView.alpha = 1.0
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.imageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
            //self.imageView.setImageWith(posterUrl! as URL)
         }*/
        if let posterPath = movie?["poster_path"] as? String {
        let smallImageRequest = NSURLRequest(url: NSURL(string: Constants.MOVIE_POSTER_LOWRES_BASE_URL+posterPath)! as URL) as URLRequest
        let largeImageRequest = NSURLRequest(url: NSURL(string: Constants.MOVIE_POSTER_HIGRES_BASE_URL+posterPath)! as URL) as URLRequest
        
        self.imageView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // smallImageResponse will be nil if the smallImage is already available
                // in cache (might want to do something smarter in that case).
                self.imageView.alpha = 0.0
                self.imageView.image = smallImage;
                
                UIView.animate(withDuration:0.5, animations: { () -> Void in
                    
                    self.imageView.alpha = 1.0
                    
                    }, completion: { (sucess) -> Void in
                        
                        // The AFNetworking ImageView Category only allows one request to be sent at a time
                        // per ImageView. This code must be in the completion block.
                        self.imageView.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                
                                self.imageView.image = largeImage;
                                
                            },
                            failure: { (request, response, error) -> Void in
                                // do something for the failure condition of the large image request
                                // possibly setting the ImageView's image to a default image
                        })
                })
            },
            failure: { (request, response, error) -> Void in
                // do something for the failure condition
                // possibly try to get the large image
        })
        }
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
