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

class TopMoviesTableViewController: UITableViewController {

    let topMovies = ["m1", "m2" , "m3"]
    let url = "https://api.themoviedb.org/3/movie/top_rated"
    let api_key = "2376e4c6e95d883b82d31e2a21d09c1e"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let params : [String : String] = ["api_key" : self.api_key]
        
        getmovieData(url: self.url, parameters: params)
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topMovies.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath)
        cell.textLabel?.text = self.topMovies[indexPath.row]

        

        return cell
    }
    

    //MARK: - Networking
    
    func getmovieData(url: String, parameters: [String: String]) {
        
        
        // asyncronize fetching data from the API
        
        _ = Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
                response in
                if response.result.isSuccess {
                    
                    print("Success! Got movie data")
                    let movieJSON : JSON = JSON(response.result.value!)
                    
                    
                    print(movieJSON )
                    
                    // self.updateWeatherData(json: weatherJSON)
                    
                }
                else {
                    print("Error")
                    
                }
            }
        
        
        print()
            
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
