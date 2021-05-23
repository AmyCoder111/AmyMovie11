//
//  MovieSearchViewController.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 2/28/21.
//

import UIKit
import Combine

//TODO: tests
class MovieSearchViewController: UIViewController, UISearchResultsUpdating {

    private var viewModel: MovieSearchViewModelType?
    private var subscription: AnyCancellable?
    private var items = [MovieItemViewModelType]()
    private var input = ""
    
    private static let cellIdentifier = "movieCell"
    private static let cellHeight: CGFloat = 200
    
    private let searchController = UISearchController(searchResultsController: nil)
    var tableView: UITableView = UITableView()
    
    func inject(viewModel: MovieSearchViewModelType) {
        self.viewModel = viewModel
        subscription = viewModel.state.sink(receiveValue: { [weak self] state in
            DispatchQueue.main.async {
                self?.updateView(state: state)
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Amy Movie Search"
        setupTableView()
        setupSearchController()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
        //the table view is told to use the Auto Layout constraints and the contents of its cells to determine each cell’s height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.allowsSelection = true
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: MovieSearchViewController.cellIdentifier)
        view.addSubview(tableView)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        //TODO: Localization
        searchController.searchBar.placeholder = "Search Movies"
        navigationItem.searchController = searchController
        //Ensure that the search bar doesn’t remain on the screen if the user navigates to another view controller while the UISearchController is active.
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if input == searchController.searchBar.text{
            return
        }
        input = searchController.searchBar.text ?? ""
        viewModel?.updateSearchTerm(searchController.searchBar.text ?? "")
    }
    
    private func updateView(state: MovieSearchState) {
        //TODO: activity indicators/event handling
        switch state {
            case .error:
                items = []
            case .noInternet:
                items = []
            case .results(let movies):
                items = movies
                self.tableView.tableFooterView = nil
            case .loading:
                items = []
            case .selection(_):
                //handle cases when in selection
                break
        }
        
        tableView.reloadData()
    }
}

extension MovieSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 {
            //we are at last cell, load more content
            guard let viewModel = viewModel else { return }
            self.tableView.tableFooterView = createFooterView()
            if viewModel.currentPage <= viewModel.totalPages {
                viewModel.executeSearch(input, page: viewModel.currentPage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieSearchViewController.cellIdentifier) as? MovieCell else {
            assertionFailure("Bad cell configuration")
            return UITableViewCell()
        }
        
        if indexPath.row < items.count {
            cell.viewModel = items[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMovieItem = items[indexPath.row]
        guard let movieId = currentMovieItem.movieId else { return }
        viewModel?.state.send(.selection(movieId))
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        
        let spinner = UIActivityIndicatorView()
        spinner.color = .black
        spinner.style = .medium
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        
        return footerView
    }
}

