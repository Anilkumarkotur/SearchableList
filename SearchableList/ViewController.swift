//
//  ViewController.swift
//  SearchableList
//
//  Created by Anilkumar kotur on 16/07/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

enum ListState {
    case searching, idle
}

struct Country: Decodable {
    var name: String
    var dialCode: String
}

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var theTableView: UITableView!
    
    var searchingState: ListState = .idle
    var searchedCountry = [Country]()
    var countryNameArr = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDelegate()
        self.getCountryList()
    }
    
    fileprivate func setupDelegate() {
        searchBar.delegate = self
        theTableView.delegate = self
        theTableView.dataSource = self
    }
    
    fileprivate func getCountryNameInfoFor(indexPath: IndexPath) -> (String, String) {
        switch searchingState {
        case .searching:
            return (searchedCountry[indexPath.row].name, searchedCountry[indexPath.row].dialCode )
        case .idle:
            return (countryNameArr[indexPath.row].name, countryNameArr[indexPath.row].dialCode)
        }
    }
    
    fileprivate func getNumberOfRowsInSection() -> Int {
        switch searchingState {
        case .searching:
            return searchedCountry.count
        case .idle:
            return countryNameArr.count
        }
    }
    
    fileprivate func getCountryList() {
        let currentBundle = Bundle(for: ViewController.self) //Check for alternative in product
        
        if let path = currentBundle.path(forResource: "CountryCodes", ofType: "json") {
            guard let dataFormJsonFile = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return
            }
            if let countryList = try? JSONDecoder().decode([Country].self, from: dataFormJsonFile) {
                self.countryNameArr = countryList
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let countryName = self.getCountryNameInfoFor(indexPath: indexPath).0
        
        cell.textLabel?.text = countryName
        cell.detailTextLabel?.text = self.getCountryNameInfoFor(indexPath: indexPath).1
        cell.imageView?.image = UIImage(named: countryName)
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchingState = .searching
        searchedCountry = countryNameArr.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.theTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchingState = .idle
        self.theTableView.reloadData()
    }
}
