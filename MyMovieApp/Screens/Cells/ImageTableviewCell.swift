//
//  ImageTableviewCell.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 7.04.2021.
//

import UIKit

class ImageTableviewCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var movieViewModelList : [MovieViewModel]?
    var movies = [MovieDetail]()
    var movie = [Movie]()
    var movieType = MovieType.nowPlaying
    var category: MovieDBCategory = .NowPlaying
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        //    collectionView.register(ImageSliderCollectionViewCell.self, forCellWithReuseIdentifier: "ImageSliderCollectionViewCell")
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        self.collectionView.register(UINib(nibName: "ImageSliderCollectionViewCell" , bundle: nil),forCellWithReuseIdentifier: "ImageSliderCollectionViewCell")
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(UIScreen.main.bounds.width - 40)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(scrollView.contentSize.width)
        var newPage = Float(pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? pageControl.currentPage + 1 : pageControl.currentPage - 1)
            if newPage < 0 { newPage = 0 }
            if (newPage > contentWidth / pageWidth) { newPage = ceil(contentWidth / pageWidth) - 1.0 }
        }
        
        pageControl.currentPage = Int(newPage)
        var targetX: CGFloat = 0
        if pageControl.currentPage != 0 {
            targetX = CGFloat(pageWidth * Float(pageControl.currentPage))
        }
        
        let point = CGPoint (x: targetX, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    func loadMovies() {
        print("Loading movies for \(self.movieType)")
        APIClient.shared.getMovies(self.category) { movies, error in
            if let error = error {
                print("There was an error loading movies! ")
                print(error)
                return
            }
            self.movie += self.movie
        }
    }
}

extension ImageTableviewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCollectionViewCell", for: indexPath) as! ImageSliderCollectionViewCell
        cell.setupUI(movies[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
    }
    
}

extension ImageTableviewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ImageTableviewCell : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}
