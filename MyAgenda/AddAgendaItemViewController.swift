//
//  AddAgendaItemViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

// add or edit an agenda item

class AddAgendaItemViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priorityChoice: UISegmentedControl!
    @IBOutlet weak var categoryChoice: UISegmentedControl!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    var agendaItem: AgendaItem?
    var defaultCategoryNumber: Int?
    var defaultPriority: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        descriptionField.delegate = self
        
        dueDatePicker.tintColor = .darkGray
        dueDatePicker.sizeThatFits(CGSize(width: 200, height: 100))
        dueDatePicker.minimumDate = Date()  // no due dates before today

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = (agendaItem == nil) ?
            NSLocalizedString("Add To Agenda", comment: "Add To Agenda") :
            NSLocalizedString("Edit Agenda", comment: "Edit Agenda")

        if let existingAgendaItem = agendaItem {
            descriptionField.text = existingAgendaItem.descriptionText
            dueDatePicker.date = (existingAgendaItem.dueDate)! as Date
            categoryChoice.selectedSegmentIndex = Int(existingAgendaItem.category)
            priorityChoice.selectedSegmentIndex = Int(existingAgendaItem.priority) - 1  // zero-based
        } else {
            categoryChoice.selectedSegmentIndex = defaultCategoryNumber ?? 0
            priorityChoice.selectedSegmentIndex = (defaultPriority ?? 1) - 1  // zero-based
        }
        
        descriptionField.becomeFirstResponder()
    }
    

    @IBAction func saveWasPressed(_ sender: Any) {
        let priority = priorityChoice.selectedSegmentIndex + 1 // adjust from zero-based
        let category = categoryChoice.selectedSegmentIndex
        let dueDate = dueDatePicker.date
        let descriptionText = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if descriptionText != "" {
            let model = ModelController.sharedInstance
            if let existingAgendaItem = agendaItem {
                existingAgendaItem.priority = Int16(priority)
                existingAgendaItem.category = Int16(category)
                existingAgendaItem.dueDate = dueDate as NSDate
                existingAgendaItem.descriptionText = descriptionText
                model.saveContext()
            } else  {
                AnalyticsController.sharedInstance.addedAgendaItem()

                _ = model.addAgendaItem(descriptionText: descriptionText,
                                        category: category,
                                        priority: priority,
                                        dueDate: dueDate)
            }
            
            // and return to the previous controller
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveWasPressed(descriptionField)
        return true
    }
    
}


