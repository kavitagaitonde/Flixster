//
//  FlixsterViewController.swift
//  Flixster
//
//  Created by Kavita Gaitonde on 9/12/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MBProgressHUD

class FlixsterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieImageView: UIImageView!
    var moviesData:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //fetch movies from server
        let url = URL(string:Constants.MOVIES_NOW_PLAYING_URL)
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
            { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.moviesData = dictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.MOVIE_CELL_HEIGHT)
    }
    
   /* func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.MOVIE_TABLEVIEW_SECTION_HEADER_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(Constants.MOVIE_TABLEVIEW_SECTION_FOOTER_HEIGHT)
    }*/

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlixsterCell", for: indexPath) as! MovieTableViewCell
        let movieData = self.moviesData[indexPath.row]
        cell.movieTitleLabel?.text = movieData["title"] as? String
        cell.movieDescriptionLabel?.text = movieData["overview"] as? String
        if let posterPath = movieData["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.MOVIE_THUMBNAIL_BASE_URL+posterPath)
            cell.movieImageView.setImageWith(posterUrl! as URL)
        }
        return cell
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMovieDetailsSegue" {
            let cell = sender as! MovieTableViewCell
            if let indexPath = self.tableView.indexPath(for: cell) {
                let detailsController = segue.destination as! MovieDetailsViewController
                detailsController.movie = self.moviesData[indexPath.row]
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    

}
