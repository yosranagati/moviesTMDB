//
//  movieViewModel.swift
//  moviesTMDB
//
//  Created by mac on 2/25/19.
//  Copyright © 2019 yosra. All rights reserved.
//

import Foundation

struct movieViewModel{
    let title :String
    let poster_path: String
    let genre:String
    let id : Int32
    
    init(movie : TopRated){
        self.title = movie.title!
        self.poster_path = movie.poster_path!
        self.genre = movie.genre ?? ""
        self.id = movie.id
        
    }
}
