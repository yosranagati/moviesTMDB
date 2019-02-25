//
//  CustomMessageCell.swift
//  Flash Chat
//
//  Created by Angela Yu on 30/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

class CustomMovieCell: UITableViewCell {


   
    @IBOutlet var genre: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    var movieViewModel:movieViewModel!{
        didSet{
            self.title?.text = movieViewModel.title
            self.genre.text = movieViewModel.genre
            let pictureString = movieViewModel.poster_path
            
            let pictureURL = URL(string: "https://image.tmdb.org/t/p/w500/\(pictureString)")
            let data = try? Data(contentsOf: pictureURL!)
            
                    if let imageData = data {
                      self.poster?.image = UIImage(data: imageData)
                    }
            

          

            
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }
    
    
    

    


}


