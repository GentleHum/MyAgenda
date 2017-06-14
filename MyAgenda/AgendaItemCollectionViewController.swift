//
//  AgendaItemCollectionViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 6/12/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit


class AgendaItemCollectionViewController: UICollectionViewController {

    internal struct Storyboard {
        static let detailSegue = "AgendaItemDetailSegue"
        static let detailController = "AgendaItemDetailViewController"
        static let cellIdentifier = "AgendaItemCVC"
        static let sectionHeader = "AgendaItemSectionHeader"
    }
    
    
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
        let height: CGFloat = 44.0   // zap don't hard code this
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return agendaItems.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return agendaItems[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellIdentifier,
                                                      for: indexPath) as! AgendaItemCollectionViewCell
        
        // Configure the cell
        cell.agendaItem = agendaItems[indexPath.section][indexPath.row]
        
        return cell
        
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
        let itemToMove = agendaItems[sourceIndexPath.section][sourceIndexPath.row]
        agendaItems[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        agendaItems[destinationIndexPath.section].insert(itemToMove, at: destinationIndexPath.row)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func showAlert(title: String, sender: UIView) {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Mark as Complete", style: .default, handler: { action in
                
                collectionView.performBatchUpdates({Void in
                    let itemToDelete = self.agendaItems[indexPath.section][indexPath.row]
                    ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
                    self.agendaItems[indexPath.section].remove(at: indexPath.row)
                    self.collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { action in
                
                // perform segue to agenda item detail
                self.performSegue(withIdentifier: Storyboard.detailSegue,
                                  sender: self.agendaItems[indexPath.section][indexPath.row])
                
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                
                collectionView.performBatchUpdates({Void in
                    let itemToDelete = self.agendaItems[indexPath.section][indexPath.row]
                    ModelController.sharedInstance.deleteAgendaItem(itemToDelete)
                    self.agendaItems[indexPath.section].remove(at: indexPath.row)
                    self.collectionView?.deleteItems(at: [indexPath])
                }, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.popoverPresentationController?.sourceRect = sender.frame
            alert.popoverPresentationController?.sourceView = collectionView
            
            self.present(alert, animated: true, completion: nil)
        }
        
        let item = agendaItems[indexPath.section][indexPath.row]
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
