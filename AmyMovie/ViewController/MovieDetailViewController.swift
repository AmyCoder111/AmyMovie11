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
    private var spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
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
    
    private func setupActivityIndicator() {
        spinner.startAnimating()
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        spinner.isHidden = true
    }
    
    private func updateView(state: MovieDetailState) {
        switch state {
            case .error:
                spinner.isHidden = true
                contentView.isHidden = true
                break
            case .noInternet:
                spinner.isHidden = true
                contentView.isHidden = true
                break
            case .result(let movieDetail):
                spinner.isHidden = true
                contentView.isHidden = false
                updateSubviews(movieDetail)
            case .loading:
                spinner.isHidden = false
                contentView.isHidden = true
                break
        }
    }
    
    private func updateSubviews(_ detailViewModel: MovieDetailItemViewModelType?) {
        guard let detailModel = detailViewModel else { return }
        self.contentView.viewModel = detailModel
    }
}
