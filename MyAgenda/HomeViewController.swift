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
        static let mainCellIdentifier = "HomeTVC"
        static let todaySegue = "TodaySegue"
        static let next7DaysSegue = "Next7DaysSegue"
        static let allItemsSegue = "AllItemsSegue"
    }
    
    private enum HomeListItemRows: Int {
        case today = 0
        case next7Days = 1
        case all = 2
    }
    
    private var homeListItems = [
        HomeListItem(name: "Today", iconName: "Today-icon.png", taskCount: 0),
        HomeListItem(name: "Next 7 Days", iconName: "Next7Days-icon.png", taskCount: 0),
        HomeListItem(name: "All", iconName: "AllItems-icon", taskCount: 0),
    ]
    
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        updateTaskCounts()
    }
    
    private func updateTaskCounts() {
        homeListItems[HomeListItemRows.today.rawValue].taskCount = 0
        homeListItems[HomeListItemRows.next7Days.rawValue].taskCount = 2
        homeListItems[HomeListItemRows.all.rawValue].taskCount = 12
    }
    
    // MARK: Table view delegate and data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mainCellIdentifier, for: indexPath) as! HomeTableViewCell
        
        // configure the cell
        let homeListItem = homeListItems[indexPath.row]
        cell.countLabel.text = (homeListItem.taskCount > 0) ? String(homeListItem.taskCount) : " "
        cell.icon.image = UIImage(named: homeListItem.iconName)
        cell.nameLabel.text = homeListItem.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case HomeListItemRows.today.rawValue:
            performSegue(withIdentifier: Storyboard.todaySegue, sender: nil)
            
        case HomeListItemRows.next7Days.rawValue:
            performSegue(withIdentifier: Storyboard.next7DaysSegue, sender: nil)

        case HomeListItemRows.all.rawValue:
            performSegue(withIdentifier: Storyboard.allItemsSegue, sender: nil)
            
        default: break
            
        }
    }


}

// kept around just in case
//            let myWebView = self.storyboard!.instantiateViewController(withIdentifier: "TodayVC") as! TodayViewController
//            self.present(myWebView, animated: true, completion: nil)

