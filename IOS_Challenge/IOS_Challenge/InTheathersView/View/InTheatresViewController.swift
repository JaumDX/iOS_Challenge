//
//  ViewController.swift
//  IOS_Challenge
//
//  Created by João Vitor Paiva on 03/03/20.
//  Copyright © 2020 joaovitorpaiva. All rights reserved.
//

import UIKit

class InTheatresViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: InTheatresViewModelProtocol!{
        didSet{
            if self.tableView.isHidden{
                self.tableView.isHidden = false
            }
            self.viewModel.didChangeInTheathers = { [unowned self] viewModel in
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        viewModel = InTheatresViewModel(networkManager: NetworkManager())
        viewModel.fetchNowPlayingMovies()
        
    }
}

extension InTheatresViewController : UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.inTheatres.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "MovieCell"
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? InTheatresTableViewCell else{
            fatalError("Could not setup table view cell.")
        }
        
        cell.movieTitle.text = viewModel.inTheatres.movies[indexPath.row].title
        if viewModel.inTheatres.movies[indexPath.row].posterPath != nil{
            cell.fetchImageData(imagePath: viewModel.inTheatres.movies[indexPath.row].posterPath!)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.inTheatres.movies.count - 1{
            viewModel.fetchNowPlayingMovies()
        }
    }
    
    //MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailSegue", sender: self)
    }
    
}
