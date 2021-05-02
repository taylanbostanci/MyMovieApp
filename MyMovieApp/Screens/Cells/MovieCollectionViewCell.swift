//
//  MovieCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    
    var movieViewModel: MovieViewModel? {
        didSet{
            movieNameLabel?.text = movieViewModel?.title
            movieReleaseDateLabel?.text = movieViewModel?.release_date
            movieRatingLabel?.text = movieViewModel?.rating
            guard let url = movieViewModel?.posterURL else { return }
            loadImage(fromURL: url)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        loadImage()
    }
    
    func setupUI(){
        layer.shadowRadius = 4
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        movieNameLabel?.text = movieViewModel?.title
        movieReleaseDateLabel?.text = movieViewModel?.release_date
        movieRatingLabel?.text = movieViewModel?.rating
    }
    
    func loadImage(){
        guard let url = movieViewModel?.posterURL else { return }
        loadImage(fromURL: url)
    }
    
    override func prepareForReuse() {
        self.movieImageView?.image = Images.emptyImage
    }
    
    private func loadImage(fromURL: String) {
        Service.shared.getImage(from: fromURL, completed: { image in
            DispatchQueue.main.async {
                self.movieImageView?.image = image != nil ? image : Images.emptyImage
            }
        })
    }
}

