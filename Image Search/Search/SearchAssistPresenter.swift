//
//  SearchAssistViewDelegate.swift
//  Image Search
//
//  Created by Paul Martens on 4/1/20.
//  Copyright © 2020 PM. All rights reserved.
//

import UIKit

struct UserDefaultKeys {
    static let recentSearches = "recent"
    static let frequentlySearched = "frequent"
}

protocol SearchAssistViewDelegate: class {
    func onSearchSelection(selection: String)
}

protocol SearchAssistPresenterProtocol: class {
    /// Updates the recently searched queue with the new search query if not already listed
    func onSearch(query: String)
}

class SearchAssistPresenter: NSObject {
    weak var delegate: SearchAssistViewDelegate?
    
    var recentSearches: [String]? {
        return UserDefaults.standard.stringArray(forKey: UserDefaultKeys.recentSearches)
    }
    var frequentlySearched: [String]? {
        return UserDefaults.standard.stringArray(forKey: UserDefaultKeys.frequentlySearched)
    }
    
    init(tableView: UITableView) {
        super.init()
        // initialize the tableView delegates
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchAssist")
        // For now hardcoding frequently searched, woud eventually plan to integrate with a service to find what are the most common searches
        guard self.frequentlySearched != nil else {
            UserDefaults.standard.set(["Animals", "Nature", "Food & Drink"], forKey: UserDefaultKeys.frequentlySearched)
            return
        }
    }
    
    func queryItem(indexPath: IndexPath) -> String? {
        if let recentSearches = recentSearches, let frequentlySearched = frequentlySearched {
            let completeList = recentSearches + frequentlySearched
            return completeList[indexPath.row]
        } else if let frequentlySearched = frequentlySearched {
            return frequentlySearched[indexPath.row]
        }
        return nil
    }
}

extension SearchAssistPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedQuery = queryItem(indexPath: indexPath) else {
            return
        }
        delegate?.onSearchSelection(selection: selectedQuery)
    }
}

extension SearchAssistPresenter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recentSearches?.count ?? 0) + (frequentlySearched?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchAssist", for: indexPath)
        if let queryAtIndex = queryItem(indexPath: indexPath) {
            cell.textLabel?.text = queryAtIndex
        }
        return cell
    }
}

extension SearchAssistPresenter: SearchAssistPresenterProtocol {
    func onSearch(query: String) {
        // If the recent search list is 3 or more, remove the oldest and add the new query.
        if var recentSearches = recentSearches {
            for search in recentSearches {
                // If the item already exists then do not add it
                if search.lowercased() == query.lowercased() {
                    return
                }
            }
            for search in frequentlySearched ?? [] {
                // If the item already exists then do not add it
                if search.lowercased() == query.lowercased() {
                    return
                }
            }
            recentSearches.append(query)
            if recentSearches.count > 3 {
                recentSearches.removeFirst(1)
            }
            UserDefaults.standard.set(recentSearches, forKey: UserDefaultKeys.recentSearches)
        } else {
            UserDefaults.standard.set([query], forKey: UserDefaultKeys.recentSearches)
        }
        
    }
}
