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
    @IBOutlet weak var categoryField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Add to Agenda"
    }

    @IBAction func saveWasPressed(_ sender: Any) {
        print("saveWasPressed")  // zap
        print(descriptionField.text ?? "")
        print(categoryField.text ?? "")
        print(priorityChoice.selectedSegmentIndex)
        let priority = priorityChoice.selectedSegmentIndex + 1 // adjust from zero-based
        let descriptionText = descriptionField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let category = categoryField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if descriptionText != "" && category != "" {
            // we have an actual name so add the category
            let model = ModelController.sharedInstance
            _ = model.addAgendaItem(descriptionText: descriptionText,
                                    category: category,
                                    priority: priority,
                                    dueDate: Date())
            
            // and return to the previous controller
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
}
