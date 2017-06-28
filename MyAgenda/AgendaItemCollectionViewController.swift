//
//  AgendaItemCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/12/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AgendaItemCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    internal struct Storyboard {
        static let editItemSegue = "EditItemSegue"
        static let addItemSegue = "AddItemSegue"
        static let cellIdentifier = "AgendaItemCVC"
        static let blankCellIdentifier = "BlankAgendaItemCVC"
        static let sectionHeader = "AgendaItemSectionHeader"
    }
    
    internal var blankCellsPerSection = 1
    internal let cellHeight:CGFloat = 44.0
    internal let cellMenuHeight: CGFloat = 24.0
    internal let cellHeightWithMenu: CGFloat = 68.0
    internal let blankCellHeight: CGFloat = 1.0
    
    internal var selectedIndexPath:IndexPath?
    
    internal var agendaItems = [[AgendaItem]]()
    internal var sectionNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.installsStandardGestureForInteractiveMovement = true
        
        // no title on the navigation back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the screen layout
        let width = collectionView!.frame.width
        let height: CGFloat = cellHeight
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
        
        selectedIndexPath = nil
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // set the screen layout
        let width = collectionView?.frame.width
        let height: CGFloat = cellHeight
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width!, height: height)
        
    }
    
    internal func agendaItemNumber(from indexPath: IndexPath) -> Int {
        return indexPath.row - blankCellsPerSection
    }
    
    // override to update records moved between sections
    internal func updateRecord(at indexPath: IndexPath) {
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return agendaItems.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return agendaItems[section].count + blankCellsPerSection
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row > (blankCellsPerSection - 1) {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellIdentifier,
                                                          for: indexPath) as! AgendaItemCollectionViewCell
            cell.agendaItem = agendaItems[indexPath.section][agendaItemNumber(from: indexPath)]
            
            cell.menuIsHidden = (indexPath != selectedIndexPath)
            cell.menuDelegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.blankCellIdentifier,
                                                          for: indexPath) as! BlankCollectionViewCell
            return cell
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                            withReuseIdentifier: Storyboard.sectionHeader,
                                                                            for: indexPath) as! AgendaItemSectionHeader
        sectionHeader.title = NSLocalizedString(sectionNames[indexPath.section], comment: "category")
        
        return sectionHeader
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        let itemToMove = agendaItems[sourceIndexPath.section][agendaItemNumber(from: sourceIndexPath)]
        agendaItems[sourceIndexPath.section].remove(at: agendaItemNumber(from: sourceIndexPath))
        agendaItems[destinationIndexPath.section].insert(itemToMove,
                                                         at: agendaItemNumber(from: destinationIndexPath))
        
        if sourceIndexPath.section != destinationIndexPath.section {
            updateRecord(at: destinationIndexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row > (blankCellsPerSection - 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row > (blankCellsPerSection - 1) && selectedIndexPath == nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row > (blankCellsPerSection - 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        if proposedIndexPath.row > (blankCellsPerSection - 1) {
            return proposedIndexPath
        } else {
            return IndexPath(row: blankCellsPerSection, section: proposedIndexPath.section)
        }
    }
    
    internal func getItemHeight(from indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return cellHeightWithMenu
        } else {
            return (indexPath.row > (blankCellsPerSection - 1)) ? cellHeight : blankCellHeight
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = view.frame.width
        let itemHeight = getItemHeight(from: indexPath)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        collectionView.reloadData()
        
    }
    
    
    // MARK: - Navigation
    
    internal func setAddItemDefaults(forController controller: AddAgendaItemViewController) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.editItemSegue {
            if let agendaItem = sender as? AgendaItem {
                let controller = segue.destination as! AddAgendaItemViewController
                controller.agendaItem = agendaItem
            }
        } else if segue.identifier == Storyboard.addItemSegue {
            let controller = segue.destination as! AddAgendaItemViewController
            setAddItemDefaults(forController: controller)
        }
        
    }
    
}

extension AgendaItemCollectionViewController: AgendaItemMenuDelegate {
    func didPressComplete() {
        
        AnalyticsController.sharedInstance.completedAgendaItem()
        
        // for now, complete and delete are the same.
        // In the future, may add feature to keep completed tasks in a backlog.

        deleteAgendaItem()
    }
    
    func didPressDelete() {
        AnalyticsController.sharedInstance.deletedAgendaItem()
        deleteAgendaItem()
    }
    
    func didPressEdit() {
        AnalyticsController.sharedInstance.editedAgendaItem()

        // perform segue to edit agenda item detail
        if let indexPath = selectedIndexPath {
            self.performSegue(withIdentifier: Storyboard.editItemSegue,
                              sender: self.agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)])
        }
    }
    
    internal func deleteAgendaItem() {
        if let indexPath = selectedIndexPath {
            
            selectedIndexPath = nil
            collectionView?.performBatchUpdates({Void in
                let itemToDelete = self.agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)]
                ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
                self.agendaItems[indexPath.section].remove(at: self.agendaItemNumber(from: indexPath))
                self.collectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
            
        }
    }
   
}
