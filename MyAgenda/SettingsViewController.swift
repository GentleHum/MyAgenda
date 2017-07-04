//
//  SettingsViewController.swift
//  MyAgenda
//
//  Created by Michael Vork on 7/4/17.
//  Copyright © 2017 Mike Vork. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var categoryChoice: UISegmentedControl!
    
    @IBOutlet weak var priorityChoice: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let settings = SettingsController.sharedInstance

        categoryChoice.selectedSegmentIndex = settings.defaultCategory
        priorityChoice.selectedSegmentIndex = settings.defaultPriority - 1
        
        self.navigationItem.title =
            NSLocalizedString("Settings", comment: "Settings") 
    }

    @IBAction func saveWasPressed(_ sender: UIBarButtonItem) {

        let settings = SettingsController.sharedInstance
        
        settings.defaultCategory = categoryChoice.selectedSegmentIndex
        settings.defaultPriority = priorityChoice.selectedSegmentIndex + 1
        
        settings.save()
        
        _ = navigationController?.popViewController(animated: true)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
