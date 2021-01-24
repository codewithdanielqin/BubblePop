//
//  BubbleViewController.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit
import SpriteKit

protocol BubbleViewControllerDelegate: class {
    func goToHighScore()
}

class BubbleViewController: UIViewController {
    
    weak var delegate: BubbleViewControllerDelegate?
    
    // Setting up View for SKScene Game Play
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let mainView = self.view as! SKView
        
        if mainView.scene == nil {
            
            // Create GameScene
            let scene = GameScene(size: mainView.bounds.size)
            scene.parentViewController = self
            mainView.presentScene(scene)
        }
        
    }
    
    // After game,show HighScore
    func gameEnded() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.goToHighScore()
    }
    
}

