//
//  HomeViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/20/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit
import SwiftDate

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    private struct Storyboard {
        static let homeCellIdentifier = "HomeTVC"
        static let segmentChoiceCellIdentifier = "SegmentChoiceTVC"
        static let categoryCellIdentifier = "CategoryTVC"
        static let filterCellIdentifier = "FilterTVC"
        
        static let todaySegue = "TodaySegue"
        static let next7DaysSegue = "Next7DaysSegue"
        static let allItemsSegue = "AllItemsSegue"
        
        static let daysCVC = "DaysCVC"
        static let allItemsCVC = "AllItemsCVC"
        static let categoryCVC = "CategoryCVC"
        
        static let rowHeight = 44
    }
    
    private enum HomeListItemRows: Int {
        case today = 0
        case next7Days = 1
        case allItems = 2
    }
    
    private let daysToShow = [1, 7]  // today, next 7 days
    
    private var homeListItems = [
        HomeListItem(name: NSLocalizedString("Today", comment: "Today"),
                     iconName: "Today-icon.png", taskCount: 0),
        HomeListItem(name: NSLocalizedString("Next 7 Days", comment: "Next 7 Days"),
                     iconName: "Next7Days-icon.png", taskCount: 0),
        HomeListItem(name: NSLocalizedString("All", comment: "All"),
                     iconName: "AllItems-icon", taskCount: 0),
    ]
    
    private var categoryListItems = [
        CategoryListItem(name: NSLocalizedString("Personal", comment: "Personal"),
                         iconName: "category-blue-icon.png", taskCount: 0),
        CategoryListItem(name: NSLocalizedString("Work", comment: "Work"),
                         iconName: "category-purple-icon.png", taskCount: 0),
        CategoryListItem(name: NSLocalizedString("School", comment: "School"),
                         iconName: "category-black-icon.png", taskCount: 0),
    ]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        navigationController?.delegate = self
        
        
        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // get rid of empty rows at bottom of table
        mainTableView.tableFooterView = UIView()
        
        // setup handler for when data in the underlying data model changes
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.dataChangeObserver),
                                               name: NSNotification.Name(rawValue: ModelController.Notifications.dataChanged),
                                               object: nil)
        
        SettingsController.sharedInstance.load()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateTaskCounts()
        mainTableView.reloadData()
    }
    
    private func updateTaskCounts() {
        
        // update the top level numbers
        let today = NSCalendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
        let tomorrow = 1.days.from(date: today!)
        let sevenDaysFromToday = 7.days.from(date: today!)
        
        homeListItems[HomeListItemRows.today.rawValue].taskCount =
            ModelController.sharedInstance.getAgendaItemCount(from: today!, to: tomorrow!)
        
        homeListItems[HomeListItemRows.next7Days.rawValue].taskCount =
            ModelController.sharedInstance.getAgendaItemCount(from: today!, to: sevenDaysFromToday!)

        // update count for all items
        homeListItems[HomeListItemRows.allItems.rawValue].taskCount =
            ModelController.sharedInstance.getAgendaItemCount()

        // update the category numbers
        for itemNumber in 0..<categoryListItems.count {
            categoryListItems[itemNumber].taskCount =
                ModelController.sharedInstance.getAgendaItemCount(matching: Int16(itemNumber))
        }
    }
    
    @objc private func dataChangeObserver() {
        updateTaskCounts()
        mainTableView.reloadData()
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
            if let categoryCell = cell as? HomeCategoryTableViewCell {
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
  
        case HomeListItemRows.today.rawValue,
             HomeListItemRows.next7Days.rawValue:
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.daysCVC) as? UINavigationController {
                if let destinationController = navigationController.childViewControllers.first as? DaysCollectionViewController {
                    destinationController.daysToShow = daysToShow[indexPath.row]
                    destinationController.showOverdueItems = true
                    self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                }
            }
            
        case HomeListItemRows.allItems.rawValue:
            if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.allItemsCVC) as? UINavigationController {
                if navigationController.childViewControllers.first is AllItemsCollectionViewController {
                    self.splitViewController?.showDetailViewController(navigationController, sender: nil)

                }
            }
        
        default:
            if indexPath.row > homeListItems.count {  // skip the category/filter table row
                let categoryNumber = indexPath.row - homeListItems.count - 1
                if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.categoryCVC) as? UINavigationController {
                    if let destinationController = navigationController.childViewControllers.first as? CategoryCollectionViewController {
                        destinationController.categoryNumber = categoryNumber
                        self.splitViewController?.showDetailViewController(navigationController, sender: nil)
                    }
                }
            }
            break
            
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let customNavigationAnimator = CustomNavigationAnimator()
        
        if operation == .push {
            customNavigationAnimator.pushing = true
        }
        
        return customNavigationAnimator
    }




}


