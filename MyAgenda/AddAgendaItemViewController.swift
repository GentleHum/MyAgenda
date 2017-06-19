//
//  AddAgendaItemViewController.swift
//  MyAgenda
//
//  Created by Mike Vork on 3/25/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class AddAgendaItemViewController: UIViewController {

    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var priorityChoice: UISegmentedControl!
    @IBOutlet weak var categoryChoice: UISegmentedControl!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Add to Agenda"
        
        dueDatePicker.tintColor = .darkGray
        dueDatePicker.sizeThatFits(CGSize(width: 200, height: 100))
        dueDatePicker.minimumDate = Date()  // no due dates before today

    }
    
    

    @IBAction func saveWasPressed(_ sender: Any) {
        let priority = priorityChoice.selectedSegmentIndex + 1 // adjust from zero-based
        let category = categoryChoice.titleForSegment(at: categoryChoice.selectedSegmentIndex) ?? ""
        let dueDate = dueDatePicker.date
        let descriptionText = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if descriptionText != "" && category != "" {
            // we have an actual name so add the category
            let model = ModelController.sharedInstance
            _ = model.addAgendaItem(descriptionText: descriptionText,
                                    category: category,
                                    priority: priority,
                                    dueDate: dueDate)
            
            // and return to the previous controller
            _ = navigationController?.popViewController(animated: true)
        }
        
    }
    
}
