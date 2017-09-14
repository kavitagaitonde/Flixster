//
//  MovieTableViewCell.swift
//  Flixster
//
//  Created by Kavita Gaitonde on 9/12/17.
//  Copyright © 2017 Kavita Gaitonde. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!

    @IBOutlet weak var movieTitleLabel: UILabel!
    
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
