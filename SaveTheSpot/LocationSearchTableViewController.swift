//
//  LocationSearchTableViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/14/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView?
}

// MARK: - Set up the API call

extension LocationSearchTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

// MARK: - Tableview Data Source Methods

extension LocationSearchTableViewController {
    
    override  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let searchResult = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = searchResult.name
        
        let address = Address.shared.parseAddress(searchResult)
        cell.detailTextLabel?.text = address
        
        return cell
    }
}

// MARK: - Navigaiton

extension LocationSearchTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toSpot" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let selectedItem = matchingItems[indexPath.row].placemark
                
                guard let name = selectedItem.name else { return }
                let address = Address.shared.parseAddress(selectedItem)
                
                let spot = SpotController.shared.create(spotWithName: name, address: address, placemark: selectedItem, context: nil)
                
                let destinationNavigationController = segue.destination as? UINavigationController
                
                let destinationVC = destinationNavigationController?.topViewController as? SpotViewController
                
                destinationVC?.spot = spot
            }
        }
    }
}
