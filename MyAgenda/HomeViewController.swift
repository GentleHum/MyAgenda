//
//  HomeViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/20/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Storyboard {
        static let homeCellIdentifier = "HomeTVC"
        static let segmentChoiceCellIdentifier = "SegmentChoiceTVC"
        static let categoryCellIdentifier = "CategoryTVC"
        static let filterCellIdentifier = "FilterTVC"
        
        static let todaySegue = "TodaySegue"
        static let next7DaysSegue = "Next7DaysSegue"
        static let allItemsSegue = "AllItemsSegue"
        
        static let todayVC = "TodayVC"
        static let next7DaysVC = "Next7DaysVC"
        static let allItemsVC = "AllItemsVC"
        static let categoryVC = "CategoryVC"
        
        static let rowHeight = 44
    }
    
    private enum HomeListItemRows: Int {
        case today = 0
        case next7Days = 1
        case allItems = 2
    }
    
    private var homeListItems = [
        HomeListItem(name: "Today", iconName: "Today-icon.png", taskCount: 0),
        HomeListItem(name: "Next 7 Days", iconName: "Next7Days-icon.png", taskCount: 0),
        HomeListItem(name: "All", iconName: "AllItems-icon", taskCount: 0),
    ]
    
    private var categoryListItems = [
        CategoryListItem(name: "Personal", iconName: "category-blue-icon.png", taskCount: 0),
        CategoryListItem(name: "Work", iconName: "category-purple-icon.png", taskCount: 0),
        CategoryListItem(name: "School", iconName: "category-black-icon.png", taskCount: 0),
        CategoryListItem(name: "Movies to watch", iconName: "", taskCount: 0),
    ]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
       
        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // get rid of empty rows at bottom of table
        mainTableView.tableFooterView = UIView()
        
        updateTaskCounts()
    }
    
    private func updateTaskCounts() {
        homeListItems[HomeListItemRows.today.rawValue].taskCount = 0
        homeListItems[HomeListItemRows.next7Days.rawValue].taskCount = 2
        homeListItems[HomeListItemRows.allItems.rawValue].taskCount = 12
        
        categoryListItems[0].taskCount = 8
        categoryListItems[1].taskCount = 0
        categoryListItems[2].taskCount = 2
        categoryListItems[3].taskCount = 4
    }
    
    // MARK: Table view delegate and data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // need to add one for the segment control in the "header"
        return homeListItems.count + 1 + categoryListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row < homeListItems.count {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.homeCellIdentifier,
                                                 for: indexPath)
            if let homeCell = cell as? HomeTableViewCell {
                homeCell.item = homeListItems[indexPath.row]
            }
            
        }
        else if indexPath.row == homeListItems.count {  // at the segment choice cell
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.segmentChoiceCellIdentifier,
                                                 for: indexPath)
            // future: configure the cell
            // nothing to do until segment control is in place
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.categoryCellIdentifier,
                                                 for: indexPath)
            if let categoryCell = cell as? CategoryTableViewCell {
                categoryCell.item = categoryListItems[indexPath.row - homeListItems.count - 1]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Storyboard.rowHeight)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case HomeListItemRows.today.rawValue:
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.todayVC) as? UINavigationController {
                if navigationController.childViewControllers[0] is TodayViewController {
                    self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                }
            }
            
        case HomeListItemRows.next7Days.rawValue:
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.next7DaysVC) as? UINavigationController {
                if navigationController.childViewControllers[0] is Next7DaysViewController {
                    self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                }
            }
            
        case HomeListItemRows.allItems.rawValue:
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.allItemsVC) as? UINavigationController {
                if navigationController.childViewControllers[0] is AllItemsTableViewController {
                    self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                }
            }
            
        default:
            if indexPath.row > homeListItems.count {  // skip the category/filter table row
                let categoryNumber = indexPath.row - homeListItems.count - 1
                if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.categoryVC) as? UINavigationController {
                    if let destinationController = navigationController.childViewControllers[0] as? CategoryViewController {
                        destinationController.categoryName = categoryListItems[categoryNumber].name
                        self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                    }
                }
            }
            break
            
        }
    }



}


