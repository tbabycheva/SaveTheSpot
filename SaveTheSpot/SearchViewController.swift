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
    }
}
