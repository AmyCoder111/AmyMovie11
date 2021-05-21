//
//  MovieDetailViewController.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/8/21.
//

import UIKit
import Combine

class MovieDetailViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModelType?
    private var subscription: AnyCancellable?
    private var detailDataViewModel: MovieDetailItemViewModelType?
    
    @IBOutlet weak var contentView: MovieDetailContentView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel?.fetchMovieDetail()
        self.contentView.setEstimatedItemSize()
    }
    
    func injectViewModel(_ viewModel: MovieDetailViewModelType) {
        self.viewModel = viewModel
        self.subscription = viewModel.state.sink(receiveValue: { [weak self] state in
            DispatchQueue.main.async {
                self?.updateView(state: state)
            }
        })
    }
    
    private func updateView(state: MovieDetailState) {
        //TODO: activity indicators
        switch state {
            case .error:
                break
            case .noInternet:
                break
            case .result(let movieDetail):
                updateSubviews(movieDetail)
            case .loading:
                break
        }
    }
    
    private func updateSubviews(_ detailViewModel: MovieDetailItemViewModelType?) {
        guard let detailModel = detailViewModel else { return }
        self.contentView.viewModel = detailModel
    }
}
