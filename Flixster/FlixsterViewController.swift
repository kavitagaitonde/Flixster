//
//  FlixsterViewController.swift
//  Flixster
//
//  Created by Kavita Gaitonde on 9/12/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import MBProgressHUD

enum FeatureType {
    case nowPlaying, topRated
}

enum LayoutType {
    case table, grid
}

class FlixsterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var tableSearchBar: UISearchBar!
    
    var refreshControl : UIRefreshControl?
    var refreshControlCollection : UIRefreshControl?
    var moviesData:[NSDictionary] = []
    var moviesDataOriginal:[NSDictionary] = []
    var featureType = FeatureType.nowPlaying
    var layoutType = LayoutType.table
    var isNetworkError = false
    var errorLabel : UILabel?
    var collectionErrorLabel : UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // table view setup
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        self.tableSearchBar.delegate = self
        
        // collection view setup
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isHidden = true
        
        //setup navigation bar
        let segmentedControl = UISegmentedControl(items: ["Table", "Grid"])
        segmentedControl.setImage(UIImage(named: "list"), forSegmentAt: 0)
        segmentedControl.setImage(UIImage(named: "grid"), forSegmentAt: 1)
        segmentedControl.sizeToFit()
        let segmentedButton = UIBarButtonItem(customView: segmentedControl)
        segmentedControl.addTarget(self, action: #selector(changeView(sender:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.leftBarButtonItem = segmentedButton

        
        //setup error view
        self.errorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 20))
        self.errorLabel?.text = "Network Error"
        self.errorLabel?.font = self.errorLabel?.font.withSize(15)
        self.errorLabel?.backgroundColor = UIColor.gray
        self.errorLabel?.textAlignment = NSTextAlignment.center
        self.errorLabel?.isHidden = true
        self.tableView.addSubview(self.errorLabel!)
        
        self.collectionErrorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 20))
        self.collectionErrorLabel?.text = "Network Error"
        self.collectionErrorLabel?.font = self.collectionErrorLabel?.font.withSize(15)
        self.collectionErrorLabel?.backgroundColor = UIColor.gray
        self.collectionErrorLabel?.textAlignment = NSTextAlignment.center
        self.collectionErrorLabel?.isHidden = true
        //self.collectionView.addSubview(self.collectionErrorLabel!)
        
        // Add UI refreshing on pull down
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl!, at: 0)
        self.refreshControlCollection = UIRefreshControl()
        self.refreshControlCollection!.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.collectionView.insertSubview(self.refreshControlCollection!, at: 0)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadData()
    }

    func changeView(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
            case 0:
                print("TABLE")
                self.layoutType = LayoutType.table
                self.collectionView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            case 1:
                print("GRID")
                self.layoutType = LayoutType.grid
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            default:
                break;
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        loadData()
    }

    func loadData() {
        //fetch movies from server
        let url = URL(string:(self.featureType == FeatureType.nowPlaying) ? Constants.MOVIES_NOW_PLAYING_URL : Constants.MOVIES_TOP_RATED_URL)
        var request = URLRequest(url: url!)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 2.0
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler:
            { (dataOrNil, response, error) in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if(self.layoutType == LayoutType.table) {
                    self.refreshControl!.endRefreshing()
                } else {
                    self.refreshControlCollection!.endRefreshing()
                }
                if (error != nil) {
                    //error
                    self.isNetworkError = true
                    self.errorLabel?.isHidden = false
                    self.collectionErrorLabel?.isHidden = false

                    if(self.layoutType == LayoutType.table) {
                        self.tableView.reloadData()                        
                    } else {
                        self.collectionView.reloadData()
                    }
                } else {
                    self.isNetworkError = false
                    self.errorLabel?.isHidden = true
                    self.collectionErrorLabel?.isHidden = true
                    if let data = dataOrNil {
                        let dictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        self.moviesData = dictionary["results"] as! [NSDictionary]
                        if(self.layoutType == LayoutType.table) {
                            self.tableView.reloadData()
                        } else {
                            self.collectionView.reloadData()
                        }
                    }
                }
                if(self.moviesData.count > 0) {
                    if(self.layoutType == LayoutType.table) {
                        self.tableView.isHidden = false
                    } else {
                        self.collectionView.isHidden = false
                    }
                }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.MOVIE_CELL_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlixsterCell", for: indexPath) as! MovieTableViewCell
        let movieData = self.moviesData[indexPath.row]
        cell.movieTitleLabel?.text = movieData["title"] as? String
        //cell.movieTitleLabel?.sizeToFit()
        cell.movieDescriptionLabel?.text = movieData["overview"] as? String
        //cell.movieDescriptionLabel?.sizeToFit()
        cell.selectionStyle = .gray
        if let posterPath = movieData["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.MOVIE_THUMBNAIL_BASE_URL+posterPath)
            cell.movieImageView.setImageWith(posterUrl! as URL)
        }
        return cell
    }
    
    // MARK: - Collection View

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchBarView", for: indexPath) as! CollectionReusableView
        headerView.addSubview(self.collectionErrorLabel!)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesData.count;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! MovieCollectionViewCell
        let movieData = self.moviesData[indexPath.row]
        //cell.movieTitleLabel?.text = movieData["title"] as? String
        //cell.movieTitleLabel?.sizeToFit()
        //cell.movieDescriptionLabel?.text = movieData["overview"] as? String
        //cell.movieDescriptionLabel?.sizeToFit()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = backgroundView
        if let posterPath = movieData["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.MOVIE_THUMBNAIL_BASE_URL+posterPath)
            cell.movieImageView.setImageWith(posterUrl! as URL)
        }
        return cell
    }
    
    // MARK: - Search Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        if(searchBar.showsCancelButton == false) {
            searchBar.showsCancelButton = true
            self.moviesDataOriginal = self.moviesData
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.moviesData = self.moviesDataOriginal
        if(self.layoutType == LayoutType.table) {
            self.tableView.reloadData()
        } else {
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        
        self.moviesData = searchText.isEmpty ? self.moviesDataOriginal : self.moviesDataOriginal.filter() {
            if let title = ($0 as NSDictionary)["title"] as? String {
                return title.range(of:searchText) != nil
            } else {
                return false
            }
        }
        if(self.layoutType == LayoutType.table) {
            self.tableView.reloadData()
        } else {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showMovieDetailsSegue" {
            if(self.layoutType == LayoutType.table) {
                let cell = sender as! MovieTableViewCell
                if let indexPath = self.tableView.indexPath(for: cell) {
                    let detailsController = segue.destination as! MovieDetailsViewController
                    detailsController.movie = self.moviesData[indexPath.row]
                    self.tableView.deselectRow(at: indexPath, animated: true)
                }
            } else {
                let cell = sender as! MovieCollectionViewCell
                if let indexPath = self.collectionView.indexPath(for: cell) {
                    let detailsController = segue.destination as! MovieDetailsViewController
                    detailsController.movie = self.moviesData[indexPath.row]
                    self.collectionView.deselectItem(at: indexPath, animated: true)
                }
            }
        }
    }
    

}
