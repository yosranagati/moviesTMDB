//
//  TopMoviesTableViewController.swift
//  moviesTMDB
//
//  Created by mac on 2/5/19.
//  Copyright © 2019 yosra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import Groot

class TopMoviesTableViewController: UITableViewController {

    var topMovies = [TopRated]()
    let url = "\(API.BaseURL)top_rated"
    
    lazy var  params : [String : String] = ["api_key" : API.key]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var moviesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        getmovieData(url: self.url, parameters: params)
        loadMoviesdata()
        
        //register
        moviesTable.register(UINib(nibName: "movieCell", bundle: nil), forCellReuseIdentifier: "customMovieCell")
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMovies.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMovieCell", for: indexPath) as! CustomMovieCell
        cell.title.text = self.topMovies[indexPath.row].title!
        if let genreExsit = self.topMovies[indexPath.row].genre {
              cell.genre.text = genreExsit
        }
        else{
            cell.genre.text = ""
        }
      
        
        let pictureString =   self.topMovies[indexPath.row].poster_path!
       
        let pictureURL = URL(string: "https://image.tmdb.org/t/p/w500/\(pictureString)")
        let data = try? Data(contentsOf: pictureURL!)
        
        if let imageData = data {
          cell.poster.image = UIImage(data: imageData)
        }
      

        

        return cell
    }
    
     // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToDetails", sender: self)
    }
    

    //MARK: - Networking
    
    func getmovieData(url: String, parameters: [String: String]) {
        
        
        // asyncronize fetching data from the API
        
       let  _ = Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    
                    print("Success! Got movie data")
                    var  movieJSON  : JSON = JSON(response.result.value!)
                     // print(movieJSON["results"])
                    
                    // MARK : - to be reconsidered
                    
                    for  movie in movieJSON["results"].enumerated(){
                   
                    let moviesDic = movieJSON["results"][movie.0].dictionaryObject as [String: AnyObject]?
                        
                        
                        print(moviesDic!)
                        
                    do {
                        let _: TopRated =  try object(fromJSONDictionary: moviesDic!, inContext: self.context)
                        
                    } catch let error as NSError {
                        // handle error
                        print("error \(error)")
                    }
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
        }catch{
            print("error save this context, \(error)")
        }
        self.loadMoviesdata()
    }
    
    
    func loadMoviesdata(with request : NSFetchRequest<TopRated> = TopRated.fetchRequest()){
        
        
        do{
            self.topMovies = try context.fetch(request)
            print(request);
            
        }catch{
            print("error on get request this context, \(error)")
        }
        self.tableView.reloadData()
    }

    
    // MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        let destination = segue.destination as! DetailsViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            
            destination.movieDetails = self.topMovies[indexPath.row]
        }
        
    }
    
   

}
