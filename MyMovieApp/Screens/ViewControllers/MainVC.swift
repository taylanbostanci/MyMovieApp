//
//  MainVC.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import UIKit

protocol MovieSegmentDelegate {
    func loadMovie(movieType: MovieType)
}

class MainVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableview: UITableView!
        var movieViewModelList = [MovieViewModel]()
    var movieType = MovieType.nowPlaying
    var movieImage : [MovieViewModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.collectionView.register(UINib(nibName: "MovieSelectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MovieSelectionReusableView")
        self.collectionView.register(UINib(nibName: "MovieCollectionViewCell" , bundle: nil),forCellWithReuseIdentifier: "MovieCollectionViewCell")
        self.tableview.register(UINib(nibName: "ImageTableviewCell", bundle: nil), forCellReuseIdentifier: "ImageTableviewCell")
        self.tableview.delegate = self
        self.tableview.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        MovieSelectionReusableView.movieSegmentDelegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func loadMovies(movieType: MovieType){
        guard let currentLanguage = UserDefaults.standard.string(forKey: Keys.APP_LANGUAGE)  else { return }
        Service.init().getMovies(movieType: movieType, language: currentLanguage) { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success (let movies):
                self.movieViewModelList = movies.map( { return MovieViewModel($0)})
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.collectionView.reloadData()
                }
            case .failure (let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showError(error: error.localizedDescription)
                }
            }
        }
    }
    
    func showError(error: String){
        let alert = UIAlertController(title: "error",
                                      message: error,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ok",
                                      style: .default,
                                      handler: nil ))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MovieSelectionReusableView", for: indexPath) as! MovieSelectionReusableView
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !movieViewModelList.isEmpty{
            return movieViewModelList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        cell.movieViewModel = movieViewModelList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        if !movieViewModelList.isEmpty{
            let selectedMovieVC = MovieDetailVC(nibName: "MovieDetailVC", bundle: nil)
            selectedMovieVC.movieId = movieViewModelList[indexPath.row].id
            selectedMovieVC.backdropUrl = movieViewModelList[indexPath.row].backdropURL
            self.present(selectedMovieVC, animated: true, completion: nil)
        }
    }
}

extension MainVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0 , left: 5 , bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = collectionView.bounds.width
        cellWidth = cellWidth / 2 - 10
        
        return CGSize(width: cellWidth , height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}

extension MainVC: MovieSegmentDelegate {
    func loadMovie(movieType: MovieType) {
        self.movieType = movieType
        loadMovies(movieType: movieType)
    }
}
extension MainVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "ImageTableviewCell", for: indexPath) as! ImageTableviewCell
   //     cell.pageControl.numberOfPages = movieImage?.count ?? 0
//        cell.imageBannerCollectionView.delegate = self
//        cell.imageBannerCollectionView.prefetchDataSource = self
//        cell.pageControl.numberOfPages = imageBannerContent.items?.count ?? 0
//
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
