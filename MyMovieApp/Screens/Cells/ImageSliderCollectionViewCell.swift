//
//  ImageSliderCollectionViewCell.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 7.04.2021.
//

import UIKit
import SDWebImage
class ImageSliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var sliderImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
  
    
    func setupUI(_ movie: MovieDetail) {
        self.sliderImageView.sd_setImage(with: movie.getImageURL())
    }
}
