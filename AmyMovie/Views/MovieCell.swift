//
//  MovieCell.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 2/28/21.
//

import UIKit
import Combine


class MovieCell: UITableViewCell {
    
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var releaseDateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var subscriptions = [AnyCancellable]()
    
    var viewModel: MovieItemViewModelType? {
        willSet {
            //unsubscribe from any previews model
            unsubscribedFromViewModel()
        }
        didSet {
            //subscribe to the current model
            viewModel?.willBeSubscribedTo()
            subscribedToViewModel()
            viewModel?.hasSubscribedTo()
        }
    }
    
    override func prepareForReuse() {
        viewModel = nil
        posterView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        descriptionLabel.text = nil
    }
    
    private func unsubscribedFromViewModel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    private func subscribedToViewModel() {
        guard let viewModel = viewModel else { return }
        
        posterView.image = UIImage(named: "placeholder")
        
        subscriptions.append(viewModel.title.sink(receiveValue: { [weak self] value in
            self?.titleLabel.text = value
        }))
        
        subscriptions.append(viewModel.releaseDate.sink(receiveValue: { [weak self] value in
            self?.releaseDateLabel.text = value
        }))
        
        subscriptions.append(viewModel.overview.sink(receiveValue: { [weak self] value in
            self?.descriptionLabel.text = value
        }))
        
        subscriptions.append(viewModel.posterImage.sink(receiveCompletion: { [weak self] completion in
            if completion != .finished {
                self?.posterView.image = UIImage(named: "default_placeholder")
            }
        }, receiveValue: { [weak self] image in
            self?.posterView.image = image
        }))
        
        
    }
}
