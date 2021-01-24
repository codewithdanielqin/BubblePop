//
//  SettingViewController.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var bubblesButton: UIButton!
    @IBOutlet weak var bubblesPicker: UIPickerView!
    
    var numberOfBubbles: Int = 0
    var numberOfSeconds: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Retrieving values for Settings
        let userDefaults = UserDefaults.standard
        self.numberOfSeconds = userDefaults.integer(forKey: "timer")
        self.numberOfBubbles = userDefaults.integer(forKey: "bubbles")
        
        // Display values for Settings
        self.timerButton.setTitle("\(String(self.numberOfSeconds))s", for: .normal)
        self.bubblesButton.setTitle("\(String(self.numberOfBubbles))", for: .normal)
        
    }
    
    
    @IBAction func timerButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Set The Game Time", message: "How long you want to play?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "30s", style: .default, handler: { action in
            self.timerButton.setTitle("30s", for: .normal)
            self.numberOfSeconds = 30
        }))
        alert.addAction(UIAlertAction(title: "60s", style: .default, handler: { action in
            self.timerButton.setTitle("60s", for: .normal)
            self.numberOfSeconds = 60
        }))
        alert.addAction(UIAlertAction(title: "90s", style: .default, handler: { action in
            self.timerButton.setTitle("90s", for: .normal)
            self.numberOfSeconds = 90
        }))
        alert.addAction(UIAlertAction(title: "Reset", style: .default, handler: { action in
            self.timerButton.setTitle("60s", for: .normal)
            self.numberOfSeconds = 60
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func bubblesButtonClicked(_ sender: Any) {
        self.bubblesPicker.isHidden = false
    }
    
    func setTimer(seconds: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(seconds, forKey: "timer")
        userDefaults.synchronize()
    }
    
    func setBubbles(bubbles: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(bubbles, forKey: "bubbles")
        userDefaults.synchronize()
    }
    
    func saveSettings() {
        self.setTimer(seconds: self.numberOfSeconds)
        self.setBubbles(bubbles: self.numberOfBubbles)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.saveSettings()
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "10 Bubbles"
        case 1:
            return "15 Bubbles"
        case 2:
            return "20 Bubbles"
        case 3:
            return "30 Bubbles"
        default:
            return "Reset"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            self.bubblesButton.setTitle("10", for: .normal)
            self.numberOfBubbles = 10
        case 1:
            self.bubblesButton.setTitle("15", for: .normal)
            self.numberOfBubbles = 15
        case 2:
            self.bubblesButton.setTitle("20", for: .normal)
            self.numberOfBubbles = 20
        case 3:
            self.bubblesButton.setTitle("30", for: .normal)
            self.numberOfBubbles = 30
        default:
            self.bubblesButton.setTitle("15", for: .normal)
            self.numberOfBubbles = 15
        }
        self.bubblesPicker.isHidden = true
    }
    
}
