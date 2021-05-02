//
//  MovieDetailVC.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDescTextView: UITextView!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    var movieId: Int?
    var viewModel: DetailMovieViewModel?
    var backdropUrl: String?
    var trailerId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMovieDetails()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupVC() {
        movieImageView.contentMode = .scaleAspectFill
    }
    
    private func loadMovieDetails(){
        guard let movieId = movieId else { return }
        guard let currentLanguage = UserDefaults.standard.string(forKey: Keys.APP_LANGUAGE)  else { return }
        Service.shared.getSelectedMovie(movieId: movieId, language: currentLanguage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let movieDetails):
                DispatchQueue.main.async {
                    self.viewModel = DetailMovieViewModel(movieDetails)
                    self.movieNameLabel.text = self.viewModel?.title
                    self.movieDurationLabel.text = self.viewModel?.runtimeInMinutes
                    self.movieYearLabel.text = self.viewModel?.yearOfRelease
                    self.movieRatingLabel.text = self.viewModel?.movieRating
                    self.movieDescTextView.text = self.viewModel?.overview
                    self.movieGenreLabel.text = self.viewModel?.allGenres
                }
            case .failure: break
            }
        }
        
        guard let posterURL = backdropUrl else { return }
        Service.shared.getImage(from: posterURL, completed: { image in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.movieImageView.image = image != nil ? image : Images.emptyImage
            }
        })
    }
}
