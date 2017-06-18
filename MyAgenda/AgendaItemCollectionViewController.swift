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
        static let detailSegue = "AgendaItemDetailSegue"
        static let detailController = "AgendaItemDetailViewController"
        static let cellIdentifier = "AgendaItemCVC"
        static let blankCellIdentifier = "BlankAgendaItemCVC"
        static let sectionHeader = "AgendaItemSectionHeader"
    }
    
    internal var blankCellsPerSection = 1
    internal var cellHeight:CGFloat = 44.0
    internal var blankCellHeight: CGFloat = 1.0
    
    
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
        sectionHeader.title = sectionNames[indexPath.section]
        
        return sectionHeader
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
                                 moveItemAt sourceIndexPath: IndexPath,
                                 to destinationIndexPath: IndexPath) {
        print("in moveItemAtIndexPath: from \(sourceIndexPath) to \(destinationIndexPath)")  // zap
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
        return indexPath.row > (blankCellsPerSection - 1)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = view.frame.width
        let itemHeight: CGFloat = (indexPath.row > (blankCellsPerSection - 1)) ? cellHeight : blankCellHeight
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func showAlert(title: String, sender: UIView) {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Mark as Complete", style: .default, handler: { action in
                
                collectionView.performBatchUpdates({Void in
                    let itemToDelete = self.agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)]
                    ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
                    self.agendaItems[indexPath.section].remove(at: self.agendaItemNumber(from: indexPath))
                    self.collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                
                // perform segue to agenda item detail
                self.performSegue(withIdentifier: Storyboard.detailSegue,
                                  sender: self.agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)])
                
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                collectionView.performBatchUpdates({Void in
                    let itemToDelete = self.agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)]
                    ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
                    self.agendaItems[indexPath.section].remove(at: self.agendaItemNumber(from: indexPath))
                    self.collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.popoverPresentationController?.sourceRect = sender.frame
            alert.popoverPresentationController?.sourceView = collectionView
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let item = agendaItems[indexPath.section][self.agendaItemNumber(from: indexPath)]
        let itemDescription = item.descriptionText ?? ""
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellIdentifier,
                                                      for: indexPath) as! AgendaItemCollectionViewCell
        
        showAlert(title: "Perform which action on\n'\(itemDescription)'?", sender: cell)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.detailSegue {
            if let agendaItem = sender as? AgendaItem {
                let controller = segue.destination as! AgendaItemDetailViewController
                controller.agendaItem = agendaItem
            }
        }
        
    }
    
}
