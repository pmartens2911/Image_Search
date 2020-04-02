//
//  SearchViewController.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

protocol SearchViewProtocol: class {
    func showSearchResults(response: SearchResponse)
    func showNoResultsFound()
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchAssistView: UITableView!
    @IBOutlet weak var searchAssistViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var presenter: SearchPresenterProtocol?
    var searchAssistPresenter: SearchAssistPresenterProtocol?
    var response: SearchResponse?
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = SearchPresenter(view: self)
        
        searchAssistView.isHidden = true
        let assistPresenter = SearchAssistPresenter(tableView: searchAssistView)
        assistPresenter.delegate = self
        searchAssistPresenter = assistPresenter
        // Setup SearchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Photos"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Setup CollectionView
        if let layout = collectionView.collectionViewLayout as? PhotoCollectionLayout {
            layout.delegate = self
        }
        
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photo = sender as? PhotoDetails else {
            return
        }
        if let destinationVC = segue.destination as? PhotoDetailsViewController {
            destinationVC.photoDetails = photo
        }
    }
}

extension SearchViewController: SearchViewProtocol {
    func showSearchResults(response: SearchResponse) {
        self.response = response
        collectionView.reloadData()
    }
    
    func showNoResultsFound() {
        //TODO
    }
}

extension SearchViewController: SearchAssistViewDelegate {
    func onSearchSelection(selection: String) {
        searchAssistView.isHidden = true
        searchController.isActive = false
        searchController.searchBar.text = selection
        presenter?.onSearch(query: selection)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // show table
        searchAssistView.isHidden = false
        searchAssistView.reloadData()
        searchAssistView.layoutIfNeeded()
        searchAssistViewHeight.constant = searchAssistView.contentSize.height
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // launch search if there's text
        searchAssistView.isHidden = true
        guard let query = searchBar.text, query.count > 0 else {
            // TODO: Cancel search
            return
        }
        searchAssistPresenter?.onSearch(query: query)
        presenter?.onSearch(query: query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // launch search if there's text
    }
    
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let response = response else {
            return
        }
        let photo = response.results[indexPath.row]
        performSegue(withIdentifier: "ShowPhotoDetailsSegue", sender: photo)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let response = response else {
            return 0
        }
        return response.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let response = response else {
            return cell
        }
        let photo = response.results[indexPath.row]
        let thumbnailURL = photo.urls.thumb
        cell.imageView?.loadImage(urlString: thumbnailURL)

        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let response = response else {
            return CGSize(width: 200, height: 200)
        }
        let photo = response.results[indexPath.row]
        return CGSize(width: photo.thumbnailWidth(), height: photo.thumbnailHeight())
    }
}

extension SearchViewController: PhotoCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let response = response else {
            return CGSize(width: 200, height: 200)
        }
        let photo = response.results[indexPath.row]
        return CGSize(width: photo.thumbnailWidth(), height: photo.thumbnailHeight())
    }
}
