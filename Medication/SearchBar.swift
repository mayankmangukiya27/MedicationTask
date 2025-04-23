//
//  SearchBar.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//
//
//import Foundation
//import UIKit
//import SwiftUI
//
//struct SearchControllerSetup: UIViewControllerRepresentable {
//    typealias UIViewControllerType = UIViewController
//
//    func makeCoordinator() -> SearchCoordinator {
//        return SearchCoordinator()
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        return UIViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        // This will be called multiple times, including during the push of a new view controller
//        if let vc = uiViewController.parent {
//            vc.navigationItem.searchController = context.coordinator.search
//        }
//    }
//
//}
//
//class SearchCoordinator: NSObject {
//
//    let updater = SearchResultsUpdater()
//    lazy var search: UISearchController = {
//        let search = UISearchController(searchResultsController: nil)
//        search.searchResultsUpdater = self.updater
//        search.obscuresBackgroundDuringPresentation = false
//        search.searchBar.placeholder = "Type something"
//        return search
//    }()
//}
//
//class SearchResultsUpdater: NSObject, UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let text = searchController.searchBar.text else { return }
//        print(text)
//    }
//}
//
