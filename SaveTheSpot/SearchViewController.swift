//
//  SearchViewController.swift
//  SaveTheSpot
//
//  Created by Tetiana Babycheva on 8/14/17.
//  Copyright © 2017 babycheva. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resultSearchController: UISearchController?

    var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the search results table
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        // Set up the search bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.showsCancelButton = true
        navigationItem.titleView = resultSearchController?.searchBar
    
        // Configure the UISearchController appearance
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        // Add action to cancel button
        resultSearchController?.searchBar.delegate = self
        
        locationSearchTable.mapView = mapView
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}
