//
//  MovieSelectionReusableView.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import UIKit

class MovieSelectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var movieCategoryLabel: UILabel!
    @IBOutlet weak var segmendControl: UISegmentedControl!
    static var movieSegmentDelegate: MovieSegmentDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleLabel()
        MovieSelectionReusableView.movieSegmentDelegate?.loadMovie(movieType: .nowPlaying)
        segmentControlSetup()
    }
    
    override func prepareForReuse() {
        segmendControl.setTitle("Last Added", forSegmentAt: 0)
        segmendControl.setTitle("High Rating", forSegmentAt: 1)
        segmendControl.setTitle("Popular", forSegmentAt: 2)
        setTitleLabel()
    }
    
    func segmentControlSetup(){
        segmendControl.removeAllSegments()
        segmendControl.insertSegment(withTitle: "Last Added", at: 0, animated: true)
        segmendControl.insertSegment(withTitle: "High Rating", at: 1, animated: true)
        segmendControl.insertSegment(withTitle: "Popular", at: 2, animated: true)
        segmendControl.selectedSegmentIndex = 0
        let font = UIFont(name: "Kohinoor Bangla", size: 12)
        segmendControl.setTitleTextAttributes([NSAttributedString.Key.font: font!],
                                                for: .normal)
    }
    
    private func setTitleLabel() {
        switch segmendControl.selectedSegmentIndex {
        case 0:
            movieCategoryLabel.text = "Last Added Movies"
        case 1:
            movieCategoryLabel.text = "High Rating Movies"
        case 2:
            movieCategoryLabel.text = "Popular Movies"
        default:
            break
        }
    }
    
    @IBAction func segmendControlTapped(_ sender: Any){
        switch segmendControl.selectedSegmentIndex {
        case 0:
            MovieSelectionReusableView.movieSegmentDelegate?.loadMovie(movieType: .nowPlaying)
            setTitleLabel()
        case 1:
            MovieSelectionReusableView.movieSegmentDelegate?.loadMovie(movieType: .topRated)
            setTitleLabel()
        case 2:
            MovieSelectionReusableView.movieSegmentDelegate?.loadMovie(movieType: .popular)
            setTitleLabel()
        default:
            break
        }
    }
}
