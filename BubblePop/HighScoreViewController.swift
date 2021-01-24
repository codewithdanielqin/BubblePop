//
//  HighScoreViewController.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    
    var highPlayersList = [String]()
    var highScoresList = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        self.getHighScoresList()
        self.getPlayersList()
    }
    
    func getHighScoresList() {
        let defaults = UserDefaults.standard
        if let list = defaults.array(forKey: "highScores") as? [Int] {
            self.highScoresList = list
        }
    }
    
    func getPlayersList() {
        let defaults = UserDefaults.standard
        if let list = defaults.array(forKey: "highPlayers") as? [String] {
            self.highPlayersList = list
        }
    }
    
}

extension HighScoreViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.highPlayersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "cell")
        }
        
        cell!.textLabel?.text = String(self.highScoresList[indexPath.row])
        cell!.detailTextLabel?.text = self.highPlayersList[indexPath.row]
        
        return cell!
    }
    
}
