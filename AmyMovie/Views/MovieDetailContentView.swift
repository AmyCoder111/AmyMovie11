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
            subscribedToViewModel()
            viewModel?.hasSubscribedTo()
        }
    }
    
    func setEstimatedItemSize() {
        let collectionViewLayout = MovieDetailFlowLayout()
        collectionViewLayout.estimatedItemSize = CGSize(width: 140, height: 40)
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
        
        subscribtions.append(viewModel.overview.sink(receiveValue: { [weak self] value in
            self?.tagline.text = value
        }))
        
        subscribtions.append(viewModel.backdropImage.sink(receiveCompletion: { [weak self] completion in
            if completion != .finished {
                self?.backdropView.image = UIImage(named: "default_placeholder")
            }
        }, receiveValue: { [weak self] image in
            self?.backdropView.image = image
        }))
        
        companies.reloadData()
    }
    
}
    
extension MovieDetailContentView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel?.genres.count ?? 0
        } else if section == 1 {
            return self.viewModel?.productionCompanies.count ?? 0
        }
        
        return self.viewModel?.spokenLanguages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MovieDetailCollectionReusableView", for: indexPath) as? MovieDetailCollectionReusableView {
                var sectionText: String?
                if indexPath.section == 0 {
                    sectionText = "Genres"
                } else if indexPath.section == 1 {
                    sectionText = "ProductionCompanies"
                } else {
                    sectionText = "Languages"
                }
                sectionHeader.detailHeaderLabel.text = sectionText
                return sectionHeader
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movieDetailCell: MovieDetailCell? = nil
        guard let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as? MovieDetailCell else {
            return MovieDetailCell()
        }
        var labelText = ""
        if indexPath.section == 0 {
            labelText = self.viewModel?.genres[indexPath.row] ?? ""
            detailCell.backgroundColor = UIColor.yellow
        } else if indexPath.section == 1 {
            labelText = self.viewModel?.productionCompanies[indexPath.row] ?? ""
            detailCell.backgroundColor = UIColor.orange
        } else {
            labelText = self.viewModel?.spokenLanguages[indexPath.row] ?? ""
            detailCell.backgroundColor = UIColor.red
        }
        detailCell.detailLabel.text = labelText
        detailCell.detailLabel.preferredMaxLayoutWidth = collectionView.frame.width - 20
        movieDetailCell = detailCell
        
        return movieDetailCell ?? MovieDetailCell()
    }
    
}
