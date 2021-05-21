//
//  MovieDetailContentView.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/17/21.
//

import UIKit
import Combine

class MovieDetailContentView: UIView {
    @IBOutlet weak var backdropView: UIImageView!
    @IBOutlet weak var genres: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingScore: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var companies: UICollectionView!
    
    var subscribtions = [AnyCancellable]()
    
    var viewModel: MovieDetailItemViewModelType? {
        willSet {
            unsubscribedFromViewModel()
        }
        didSet {
            viewModel?.willBeSubscribedTo()
            subscribedToViewModel()
            viewModel?.hasSubscribedTo()
        }
    }
    
    func setEstimatedItemSize() {
        let collectionViewLayout = MovieDetailFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: 140, height: 40)
        genres.collectionViewLayout = collectionViewLayout
        companies.collectionViewLayout = collectionViewLayout
    }
    
    private func unsubscribedFromViewModel() {
        subscribtions.forEach { $0.cancel() }
        subscribtions.removeAll()
    }
    
    private func subscribedToViewModel() {
        guard let viewModel = self.viewModel else { return }
        
        backdropView.image = UIImage(named: "placeholder")
        subscribtions.append(viewModel.title.sink(receiveValue: { [weak self] value in
            self?.titleLabel.text = value
        }))
        
        subscribtions.append(viewModel.rating.sink(receiveValue: { [weak self] value in
            self?.ratingScore.text = value
        }))
        
        subscribtions.append(viewModel.tagline.sink(receiveValue: { [weak self] value in
            self?.tagline.text = value
        }))
        
        subscribtions.append(viewModel.backdropImage.sink(receiveCompletion: { [weak self] completion in
            if completion != .finished {
                self?.backdropView.image = UIImage(named: "default_placeholder")
            }
        }, receiveValue: { [weak self] image in
            self?.backdropView.image = image
        }))
        
        genres.reloadData()
        companies.reloadData()
    }
    
}
    
extension MovieDetailContentView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == genres {
            return self.viewModel?.genres.count ?? 0
        } else if collectionView == companies {
            return self.viewModel?.productionCompanies.count ?? 0
        }
        
        return self.viewModel?.productionCompanies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movieDetailCell: MovieDetailCell? = nil
        if collectionView == genres {
            guard let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? MovieGenreDetailCell else {
                return MovieGenreDetailCell()
            }
            genreCell.detailLabel.text = self.viewModel?.genres[indexPath.row]
            genreCell.detailLabel.preferredMaxLayoutWidth = collectionView.frame.width
            return genreCell
        } else if collectionView == companies {
            guard let companyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "companyCell", for: indexPath) as? MovieCompanyDetailCell else {
                return MovieCompanyDetailCell()
            }
            companyCell.detailLabel.text = self.viewModel?.productionCompanies[indexPath.row]
            companyCell.detailLabel.preferredMaxLayoutWidth = collectionView.frame.width
            movieDetailCell = companyCell
        }
        
        return movieDetailCell ?? MovieDetailCell()
    }
    
}
