//
//  ViewController.swift
//  SearchableList
//
//  Created by Anilkumar kotur on 16/07/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var theTableView: UITableView!
    
    var searchedCountry = [Country]()
    var searching: Bool = false
    
    var countryNameArr = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        theTableView.delegate = self
        theTableView.dataSource = self
        self.countryNameArr = getData()!
    }
    
    func getData() -> [Country]? {

        let currentBundle = Bundle(for: ViewController.self)
        
        if let path = currentBundle.path(forResource: "CountryCodes", ofType: "json") {
            
            guard let dataFormJsonFile = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                return nil
            }
            
            let decoder = JSONDecoder()
            let launch = try? decoder.decode([Country].self, from: dataFormJsonFile)
            return launch
            
        } else {
            return nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedCountry.count
        } else  {
            return countryNameArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if searching {
            cell.textLabel?.text = searchedCountry[indexPath.row].name
            cell.imageView?.image = UIImage(named: searchedCountry[indexPath.row].name)
        } else {
            cell.textLabel?.text = countryNameArr[indexPath.row].name
            cell.imageView?.image = UIImage(named: countryNameArr[indexPath.row].name)
        }
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searching = true
        searchedCountry = countryNameArr.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.theTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        self.theTableView.reloadData()
    }
}


struct Country: Decodable {
    var name: String
    var dialCode: String
}
