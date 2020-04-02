//
//  SearchPresenter.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import Foundation

protocol SearchPresenterProtocol: class {
    func onLoad()
    func onViewAllPhotos()
    func onSearch(query: String)
}

class SearchPresenter  {
    weak var view: SearchViewProtocol?
    var serviceApi: ServiceAPI = ServiceAPI.shared
    
    init(view: SearchViewProtocol) {
        self.view = view
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func onLoad() {
        serviceApi.getPhotos() { data, error in
            
        }
    }
    
    func onViewAllPhotos() {
        serviceApi.getPhotos() { data, error in
            
        }
    }
    
    func onSearch(query: String) {
        serviceApi.getSearchResults(query: query) { data, error in
            if let error = error {
                print(error)
            }
            do {
                guard let data = data else {
                    // TODO: Error Handling
                    return
                }
                let responseModel = try JSONDecoder().decode(SearchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // update our UI
                    self.view?.showSearchResults(response: responseModel)
                }
                
            } catch {
                print(error)
            }
            
        }
    }
}
