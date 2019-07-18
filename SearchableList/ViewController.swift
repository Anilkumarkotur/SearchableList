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
    var code: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case dialCode = "dial_code"
        case code = "code"
    }
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
    
    fileprivate func getCountryNameInfoFor(indexPath: IndexPath) -> Country {
        switch searchingState {
        case .searching:
            return searchedCountry[indexPath.row]
        case .idle:
            return countryNameArr[indexPath.row]
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
        let resourceBundle = Bundle(for: ViewController.classForCoder())
        guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return }
        if let countryList = try? PropertyListDecoder().decode([Country].self, from: data) {
            self.countryNameArr = countryList
        }
    }
    
    fileprivate func updateSearchedCountryFor(searchText: String) {
        searchedCountry = countryNameArr.filter({
            $0.name.lowercased().prefix(searchText.count) == searchText.lowercased() ||
                $0.dialCode.contains(searchText)
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getNumberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let countryName = self.getCountryNameInfoFor(indexPath: indexPath).name
        let countryCode = self.getCountryNameInfoFor(indexPath: indexPath).code
        let countryDialCode = self.getCountryNameInfoFor(indexPath: indexPath).dialCode
        
        if let emojiFlag =  emojiFlag(regionCode: countryCode) {
            cell.textLabel?.text = emojiFlag + " " + countryName 
        } else {
            cell.textLabel?.text = countryName
        }
        
        cell.detailTextLabel?.text = countryDialCode
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchingState = .searching
        self.updateSearchedCountryFor(searchText: searchText)
        self.theTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchingState = .idle
        self.theTableView.reloadData()
    }
}
