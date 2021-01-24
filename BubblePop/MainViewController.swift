//
//  MainViewController.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, BubbleViewControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var highScoreButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Getting playerName value
        let name = self.getPlayerName()
        
        // Show existing name
        self.nameTextField.text = name
    }
    
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        
        // Check if name textField is empty
        if self.nameTextField.text?.count == 0 {
            
            // If field is empty, prompt to get name
            let alert = UIAlertController(title: "Please enter your name.", message: " ", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler:{ (UIAlertAction)in
                alert.dismiss(animated: true, completion: {
                    // Do nothing
                })
            }))
            
            self.present(alert, animated: true, completion: {
                // Do nothing
            })
            
        } else {
            
            // If field is not empty, Save playerName
            let name = self.nameTextField.text!
            
            // Save playerName
            self.setPlayerName(name: name)
            
            // Provide UI Feedback to user, that their name is saved
            let alert = UIAlertController(title: "Hello  \(name)!", message: "Let's play!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler:{ (UIAlertAction)in
                alert.dismiss(animated: true, completion: {
                    // Do nothing
                })
            }))
            
            self.present(alert, animated: true, completion: {
                // Do nothing
            })
            
        }
        
    }
    
    /// Text Delegate Method
    /// Use this method to hide keyboard
    ///
    /// - Parameter textField: name
    /// - Returns:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /// Play button clicked, open GameScene
    ///
    /// - Parameter sender:
    @IBAction func playButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "GameSegue", sender: nil)
    }
    
    /// In order to navigate to score scene, to use Delegate to navigate to High Score
    func goToHighScore() {
        self.performSegue(withIdentifier: "scoreBoardSegue", sender: nil)
    }
    
    // Set self (MainViewController) as GameViewController's delegate, so that when game ends, self can open HighScore
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameSegue" {
            let bubbleVC = segue.destination as! BubbleViewController
            bubbleVC.delegate = self
        }
    }
    
    /// Get player's name from settings
    ///
    /// - Returns: name
    func getPlayerName() -> String {
        let userDefaults = UserDefaults.standard
        let name = userDefaults.string(forKey: "player") ?? ""
        return name
    }
    
    /// Set (Update) player's name in Settings
    ///
    /// - Parameter name: name
    func setPlayerName(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(name, forKey: "player")
    }
    
}
