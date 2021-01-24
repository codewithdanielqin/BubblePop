//
//  GameScene.swift
//  BubblePop
//
//  Created by XuanZhi Qin on 2021/1/16.
//  Copyright © 2021 XuanZhi Qin. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    var currentPlayer = ""
    var timeRemaining = 60
    var totalTime = 60
    var maxBubbles = 15
    var currentScore: Int = 0
    var comboCount: Int = 0
    var poppedBubbles: [SKSpriteNode] = []
    var bubbles: [SKSpriteNode] = []
    var scoreLabel: SKLabelNode!
    var timerLabel: SKLabelNode!
    var scoreboardLabel: SKLabelNode!
    var comboLabel: SKLabelNode!
    var parentViewController: BubbleViewController!
    
    /// Required function
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        // Get Game Settings
        self.getGameSettings()
        
        // Show Count Down
        self.showCountDown()
        
    }
    
    /// Get Settings from user defaults
    func getGameSettings() {
        
        // Load Game Settings
        let defaults = UserDefaults.standard
        
        self.currentPlayer = defaults.string(forKey: "player")!
        if let maxBubble = defaults.value(forKey: "bubbles") as? Int {
            self.maxBubbles = maxBubble
        } else {
            self.maxBubbles = 15; // Default to 15
        }
        if let timer = defaults.value(forKey: "timer") as? Int {
            self.timeRemaining = timer
        } else {
            self.timeRemaining = 60 // Default to 60
        }
        
        self.totalTime = timeRemaining // Total the game length
        
        // Set background Color
        self.backgroundColor = SKColor(red: 142, green: 128, blue: 192, alpha: 0.25)
    }
    
    /// Show count down
    func showCountDown() {
        
        // Create a Label to show number
        let countDownDisplay = createDisplayLabel(text: "3", position: CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2))
        countDownDisplay.horizontalAlignmentMode = .center
        countDownDisplay.fontSize = 70;
        // Create an action to count down
        let countdownAction = SKAction.run {
            var count = Int(countDownDisplay.text!)
            count = count! - 1
            countDownDisplay.text = "\(count!)"
        }
        
        // Create an action as one second waiting time
        let oneSecondAction = SKAction.wait(forDuration: 1.0)
        
        // Create an action that's combo of two
        let updateLabelEverySecond = SKAction.sequence([oneSecondAction, countdownAction])
        
        // Run actions
        countDownDisplay.run(SKAction.repeat(updateLabelEverySecond, count: 3)) {
            // When count down completes
            countDownDisplay.run(SKAction.removeFromParent())
            
            // Start Game
            self.startGame()
        }
    }
    
    func startGame() {
        
        // Reset Data
        self.bubbles = []
        self.poppedBubbles = []
        
        // Create Displays
        self.createGameStatusLabels()
        
        // Add Bubbles
        comboCount = 0;
        for _ in 0...maxBubbles {
            if (bubbles.count < maxBubbles) {
                
                // Make a random color bubble
                let color = self.generateRandomBubbleColor()
                
                // Add a bubble with image name
                self.createBubble(color: color)
            }
        }
        
        self.startTimerCountDown()
    }
    
    func startTimerCountDown() {
        
        // Create an action to update timerDisplay
        let updateTimeDisplayAction = SKAction.run {
            self.timerLabel.text = "Time: \(self.timeRemaining)"
            if self.timeRemaining != self.totalTime {
                self.refreshBubbles()
            }
            self.timeRemaining = self.timeRemaining - 1
        }
        
        // Create an action as one second waiting time
        let oneSecondAction = SKAction.wait(forDuration: 1.0)
        
        let updateLabelEverySecond = SKAction.sequence([updateTimeDisplayAction, oneSecondAction])
        timerLabel.run(SKAction.repeat(updateLabelEverySecond, count: timeRemaining)) {
            
            // Save player name and score
            self.updateHighScore(name: self.currentPlayer, score: self.currentScore)
            
            // Go to Leaderboard
            self.parentViewController.gameEnded()
            
        }
    }
    
    /// Create Displays for Score, ScoreBoard, Combo, Timer
    func createGameStatusLabels() {
        
        let userDefaults = UserDefaults.standard
        let highscores = userDefaults.array(forKey: "highScores")
        
        self.scoreLabel = createDisplayLabel(text: "Score: 0", position: CGPoint(x: 25, y: self.frame.size.height - 20))
        
        if highscores == nil {
            self.scoreboardLabel = createDisplayLabel(text: "High Score: 0", position: CGPoint(x: 25, y: self.frame.size.height - 50))
        } else if (highscores?.count)! == 0 {
            self.scoreboardLabel = createDisplayLabel(text: "High Score: 0", position: CGPoint(x: 25, y: self.frame.size.height - 50))
        } else {
            self.scoreboardLabel = createDisplayLabel(text: "High Score: \(highscores![0])", position: CGPoint(x: 25, y: self.frame.size.height - 50))
        }
        
        self.comboLabel = createDisplayLabel(text: "Combo: 0", position: CGPoint(x: 250, y: self.frame.size.height - 20))
        
        self.timerLabel = createDisplayLabel(text: "60", position: CGPoint(x: 250, y: self.frame.size.height - 50))
        
    }
    
    // Create Standard Displays
    func createDisplayLabel(text: String, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode.init(fontNamed: "HelveticaNeue-Bold")
        label.position = position
        label.horizontalAlignmentMode = .left
        label.fontColor = .red
        label.zPosition = 1000;  // Making sure label is above other displays
        label.fontSize = 21
        label.text = text
        self.addChild(label)
        
        return label
    }
    
    // This function adds a single bubble
    func createBubble(color: String) {
        
        // Add a bubble with the imageName
        let bubble = SKSpriteNode.init(imageNamed: color)
        
        // Determine the random bubble location
        bubble.isUserInteractionEnabled = false;
        bubble.name = "bubble-\(color)";
        
        self.updateLocation(bubble: bubble) // Get a feasible location for bubble
        self.bubbles.append(bubble) // Add Bubbles to the bubble array
        self.addChild(bubble)
        
    }
    
    // Randomly delete number of bubbles
    func deleteBubbles(number: Int) {
        for _ in 0...number {
            
            let randomIndex = Int(arc4random_uniform(UInt32(bubbles.count))) // Random index
            let bubble = bubbles[randomIndex] // Random bubble
            
            // Calculate duration. Bubble removes faster as timer counts down
            let duration = Double(timeRemaining) / Double(totalTime) * 0.5
            
            // Fade the bubble, and then remove it
            bubble.run(SKAction.fadeAlpha(to: 0, duration: duration))
            bubbles.remove(at: randomIndex)
        }
    }
    
    // This function returns a color from a random number between 0 and 100
    func generateRandomBubbleColor() -> String {
        
        // Create a random number
        let number = Int(arc4random_uniform(99))
        if (number < 39) {
            // 0 - 39 is 40% of 0 - 99
            return "red";
        } else if (number < 69) {
            // 40 - 69 is 30% of 0 - 99
            return "pink";
        } else if (number < 84) {
            // 70 - 84 is 15% of 0 - 99
            return "green";
        } else if (number < 94) {
            // 85 - 94 is 10% of 0 - 99
            return "blue";
        } else if (number < 99) {
            // 95 - 99 is 5% of 0 - 99
            return "black";
        } else {
            return "";
        }
    }
    
    
    /// Get a non-colliding location for the given bubble
    ///
    /// - Parameter bubble: bubble
    func updateLocation(bubble: SKSpriteNode) {
        
        /// Generate X position
        let minX = Int(bubble.size.width / 2)
        let maxX = Int(self.frame.size.width) - minX
        let rangeX = maxX - minX
        let randomX = (Int(arc4random()) % rangeX) + minX
        
        /// Generate Y position
        let minY = Int(bubble.size.height / 2)
        var maxY = Int(self.frame.size.height) - minY
        maxY -= 64 // Avoid colliding with displays
        let rangeY = maxY - minY
        let randomY = (Int(arc4random()) % rangeY) + minY
        
        /// Set the position for bubble
        bubble.position = CGPoint(x: randomX, y: randomY)
        
        // Making not colliding
        while(self.isCollidingWithOther(bubble: bubble)) {
            
            let minX = Int(bubble.size.width / 2)
            let maxX = Int(self.frame.size.width) - minX
            let rangeX = maxX - minX
            let randomX = (Int(arc4random()) % rangeX) + minX
            
            let minY = Int(bubble.size.height / 2)
            var maxY = Int(self.frame.size.height) - minY
            // Less 50 to max to avoid bubble collusion with displays
            maxY -= 64
            let rangeY = maxY - minY
            let randomY = (Int(arc4random()) % rangeY) + minY
            
            bubble.position = CGPoint(x: randomX, y: randomY)
            
            // Make bubble a smaller when trying to fit in screen
            bubble.xScale = 0.8
            bubble.yScale = 0.8
        }
    }
    
    /// This function checks if the given bubble is colliding with the bubbles already on screne
    ///
    /// - Parameter bubble: bubble
    /// - Returns: ifColiding
    func isCollidingWithOther(bubble: SKSpriteNode) -> Bool {
        if (bubbles.count == 0) {
            // No bubbles, no collision
            return false
        } else {
            // Have bubbles, check each bubble
            for index in 0...bubbles.count - 1 {
                let existingBubble = bubbles[index]
                if existingBubble.frame.intersects(bubble.frame) {
                    return true // Given bubble collides with an existing bubble
                }
            }
            return false // All bubbles checked, no collision
        }
    }
    
    /// Detects which bubble user popped
    ///
    /// - Parameters:
    ///   - touches: touch
    ///   - event: event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touchLocation = touches.first!.location(in: self)
        if self.nodes(at: touchLocation).count > 0 {
            if let buble = self.nodes(at: touchLocation)[0] as? SKSpriteNode {
                if buble.name!.contains("bubble") {
                    
                    // Add bubble to popped
                    self.poppedBubbles.append(buble)
                    
                    // Add Score
                    self.addScore(bubbleName: buble.name!)
                    
                    if let index = bubbles.firstIndex(of: buble) {
                        self.bubbles.remove(at: index)
                    }
                    buble.run(SKAction.removeFromParent())
                }
            }
        }
        
    }
    
    func addScore(bubbleName: String) {
        
        let scoreValues = [
            "bubble-red": 1,
            "bubble-pink": 2,
            "bubble-green": 5,
            "bubble-blue": 8,
            "bubble-black": 10
        ]
        let value = scoreValues[bubbleName]!
        
        // Check for Combos
        if (poppedBubbles.count > 1) {
            // If there are a number of bubbles already popped
            
            // Get the second last bubble
            let bubble = self.poppedBubbles[poppedBubbles.count - 2]
            
            // The score to be added
            var scoreAdded = value
            
            // Compare its name with the current popped bubble
            if (bubbleName == bubble.name) {
                // If they are the same color, it's a combo
                comboCount += 1
                self.comboLabel.text = "Combo: \(comboCount)" // Display Combo + 1
                scoreAdded = Int(Double(value) * 1.5) // 1.5 value for combo
            } else {
                // Otherwise, not combo
                comboCount = 1; // Reset Combo
                self.comboLabel.text = "Combo: 1" // Restart Combo Display
            }
            self.currentScore = self.currentScore + Int(scoreAdded) // Add Score
        } else {
            self.currentScore = self.currentScore + value
        }
        
        // Display Score
        self.scoreLabel.text = "Score: \(self.currentScore)"
    }
    
    /// Refresh bubbles. Remove some, Add Some
    func refreshBubbles() {
        
        // Randomly decide a number of bubbles to remove
        let numberToDelete = Int(arc4random_uniform(UInt32(bubbles.count)))
        self.deleteBubbles(number: numberToDelete)
        
        // Randomly decide a number of bubbles to add
        let numberToAdd = Int(arc4random_uniform(UInt32(maxBubbles - bubbles.count)))
        let totalNumberToAdd = numberToDelete + numberToAdd
        for _ in 0...totalNumberToAdd {
            if (bubbles.count < maxBubbles) {
                
                // Make a random color bubble
                let color = self.generateRandomBubbleColor()
                
                // Add a bubble with image name
                self.createBubble(color: color)
            }
        }
    }
    
    /// Add the new player and his/her score to highScore board
    ///
    /// - Parameters:
    ///   - name: player
    ///   - score: his score
    func updateHighScore(name: String, score: Int) {
        
        // Retrieve Settings
        let defaults = UserDefaults.standard
        var highPlayers = defaults.value(forKey: "highPlayers") as? [String]
        var highScores = defaults.value(forKey: "highScores") as? [Int]
        
        // Initialise Data if empty
        if highPlayers == nil {
            highPlayers = [String]()
        }
        highPlayers?.append(name)
        
        if highScores == nil {
            highScores = [Int]()
        }
        highScores?.append(score)
        
        // Create a new array to sort the data
        var sortedNames = [String]()
        var sortedScores = [Int]()
        
        // while not sorted
        while(!(highPlayers?.isEmpty)!) {
            
            var higherIndex = 0
            
            // Loop through highScores to find higher
            for i in 0...highScores!.count - 1 {
                if highScores![i] > highScores![higherIndex] {
                    higherIndex = i
                }
            }
            
            // Sort the high score
            sortedNames.append(highPlayers![higherIndex])
            highPlayers?.remove(at: higherIndex)
            
            sortedScores.append(highScores![higherIndex])
            highScores?.remove(at: higherIndex)
            
            higherIndex = 0
            
        }
        
        defaults.set(sortedNames, forKey: "highPlayers")
        defaults.set(sortedScores, forKey: "highScores")
        defaults.synchronize()
    }
    
    
}
