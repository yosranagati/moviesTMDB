//
//  ViewController.swift
//  moviesTMDB
//
//  Created by mac on 2/5/19.
//  Copyright © 2019 yosra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Groot
import CoreData

class DetailsViewController: UIViewController {
    
    @IBOutlet var moviePoster: UIImageView!
    @IBOutlet var votCount: UILabel!
    
    @IBOutlet var genre: UILabel!
    @IBOutlet var language: UILabel!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet var avVote: UILabel!
    var movieDetailsData = [TopRated]()
    var url = "https://api.themoviedb.org/3/movie/"
    let api_key = "2376e4c6e95d883b82d31e2a21d09c1e"
    var params : [String : String] = [:]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var movieDetails : TopRated?{
        didSet{
            print("selectedMovie \(movieDetails!)")
           
            params = ["api_key" : self.api_key]
            self.title = movieDetails?.title
            let number = movieDetails?.id
            url += "\(number!)"
            print(url)
            getmovieData(url: url, parameters: params)
          
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Networking
    
    func getmovieData(url: String, parameters: [String: String]) {
        
        
        // asyncronize fetching data from the API
        
        _ = Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got movie data")
                var  movieJSON  : JSON = JSON(response.result.value!)
             
                
                // MARK : - to be reconsidered

                var moviesDic = movieJSON.dictionaryObject as [String: AnyObject]?
                var genre : String = ""
                for (index,genreItem) in movieJSON["genres"]{
                   
                   genre += " \(genreItem["name"])"
                }
                
                
                
                
                
                 moviesDic!["genre"] = genre as AnyObject
                    do {
                        let _: TopRated =  try object(fromJSONDictionary: moviesDic!, inContext: self.context)
                        
                    } catch let error as NSError {
                        // handle error
                        print("error \(error)")
                    }
                
                self.saveContext()
            
            }
            else {
                print("Error")
                
            }
        }
        
        
        
        
        
        
        
    }
    

    
    //MARK - Core Data monupulation methods
    func saveContext(){
        do{
            try context.save()
            self.loadMoviedata()
            
        }catch{
            print("error save this context, \(error)")
        }
        self.loadMoviedata()
        
     
    }
    
    
    func loadMoviedata(with request : NSFetchRequest<TopRated> = TopRated.fetchRequest()){
        let movePredict = NSPredicate(format:"id = %ld", movieDetails!.id)
        request.predicate = movePredict
        
        do{
            self.movieDetailsData = try context.fetch(request)
           // print(request);
            self.updateData();
           

        }catch{
            print("error on get request this context, \(error)")
        }
       
    }
    
//    func fetchGenres(){
//        let request: NSFetchRequest<Genre> = Genre.fetchRequest()
////        let movePredict = NSPredicate(format:"parentMovie.id = %ld", movieDetails!.id)
////        request.predicate = movePredict
//        print(request)
//
//        do{
//            let genres = try context.fetch(request)
//
//             print("genres\(genres)");
//
//
//        }catch{
//            print("error on get request this context, \(error)")
//        }
//
//    }
    
    func updateData(){
       
        //display poster
        let pictureString =   movieDetailsData[0].poster_path!
        
        let pictureURL = URL(string: "https://image.tmdb.org/t/p/w500\(pictureString)")
     
        let data = try? Data(contentsOf: pictureURL!)
        
        if let imageData = data {
             self.moviePoster.image = UIImage(data: imageData)
        }
        
        avVote.text? = String(movieDetailsData[0].voteAv)
        votCount.text? = String(movieDetailsData[0].voteCount)
        releaseDate.text? = movieDetailsData[0].release_date!
        language.text? = movieDetailsData[0].orignalLanguage!
        genre.text? = movieDetailsData[0].genre!
        
        
    }


}

