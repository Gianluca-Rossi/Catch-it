//
//  GameViewController.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 16/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var scnView: SCNView!
    
    var scnScene: SCNScene!
    var sticksScene : SCNScene!
    
    var horizontalCameraNode: SCNNode!
    var verticalCameraNode: SCNNode!
    var spawnedEnemiesNode: SCNNode!
    var spikeNode: SCNNode!
    var fingerNode: SCNNode!
    var pawNode: SCNNode!
    var pandaNode: SCNNode!
    var bearNode: SCNNode!
    var wurstelNode: SCNNode!
    var holesLightsNode: SCNNode!
    var missedLight: SCNNode!
    var livesLabel: SCNNode!
    var livesLeftLabel: SCNNode!
    var gameOverLabel: SCNNode!
    var heart: SCNNode!
    var scoreBillboard: SCNNode!
    var scoreValue: SCNNode!
    var scoreSign: SCNNode!
    var HUD: SCNNode!
    
    var availableSticks : [SCNNode] = []
    
    var heartInitialScale: CGFloat!
    
    var bottomBillboardLights : [SCNNode] = []
    var topBillboardLights : [SCNNode] = []
    
    
    var livesLeftLabelText: SCNText!
    var gameOverLabelText: SCNText!
    var scoreValueText: SCNText!
    
    var spawnTime: TimeInterval = 0
    var spawnPositions : [SCNVector3]!
    var availablePositions : [Int] = []
    
    var gameState = GameStateType.splashScreen
    
    let duration = 3.0
    
    var lives = 5
    var score = 0
    var randomPositionIndex = 0
    var digitsToAdd = 0
    var digitsString = ""
    var scoreString = ""
    
    var lostScreenisShowed = false
    
    var bounceAction : SCNAction!
    var blink : SCNAction!
    var lightBeam : SCNAction!
    var rotateAction : SCNAction!
    var shakeAction : SCNAction!
    var pulseAction : SCNAction!
    var pulseForeverAction : SCNAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupNodes()
        setupPositions()
        setupActions()
        
        gameState = .playing
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupView() {
        scnView = (self.view as! SCNView)
        scnView.delegate = self
        scnView.isPlaying = true
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        scnScene = SCNScene(named: "art.scnassets/Game.scn")
        scnView.scene = scnScene
        
        sticksScene = SCNScene(named: "art.scnassets/sticks.scn")
    }
    
    func setupPositions() {
        spawnPositions = [SCNVector3(-0.74, 0, 1.3),
                          SCNVector3(0, 0, 1.3),
                          SCNVector3(0.74, 0, 1.3),
                          SCNVector3(-0.74, 0, 0),
                          SCNVector3(0, 0, 0),
                          SCNVector3(0.74, 0, 0),
                          SCNVector3(-0.74, 0, -1.3),
                          SCNVector3(0, 0, -1.3),
                          SCNVector3(0.74, 0, -1.3)]
        
        //Creates an array with the available spawn positions
        availablePositions.reserveCapacity(spawnPositions.count)
        for i in 0..<spawnPositions.count {
            availablePositions.append(i)
        }
        
        
    }
    
    func setupNodes() {
        
        fingerNode = sticksScene.rootNode.childNode(withName: "Finger", recursively: true)!
        pawNode = sticksScene.rootNode.childNode(withName: "Paw", recursively: true)!
        wurstelNode = sticksScene.rootNode.childNode(withName: "Wurstel", recursively: true)!
        spikeNode = sticksScene.rootNode.childNode(withName: "spike", recursively: true)!
        pandaNode = sticksScene.rootNode.childNode(withName: "panda", recursively: true)!
        bearNode = sticksScene.rootNode.childNode(withName: "bear", recursively: true)!
        
        fingerNode.name = "finger"
        pawNode.name = "paw"
        wurstelNode.name = "wurstel"
        spikeNode.name = "spike"
        pandaNode.name = "panda"
        bearNode.name = "bear"
        
        spawnedEnemiesNode = scnScene.rootNode.childNode(withName: "SpawnedSticks", recursively: true)!
        livesLabel = scnScene.rootNode.childNode(withName: "LivesText", recursively: true)!
        let livesLabelText = livesLabel.geometry as? SCNText
        livesLabelText?.font = UIFont.systemFont(ofSize: 24, weight: .black)
        livesLeftLabel = scnScene.rootNode.childNode(withName: "LivesLeftText", recursively: true)!
        livesLeftLabelText = livesLeftLabel.geometry as? SCNText
        livesLeftLabelText.font = UIFont.systemFont(ofSize: 36, weight: .black)
        
        
        //TOGLIERE?
        gameOverLabel = scnScene.rootNode.childNode(withName: "GameOverText", recursively: true)!
        gameOverLabelText = gameOverLabel.geometry as? SCNText
        gameOverLabelText.font = UIFont.systemFont(ofSize: 24, weight: .black)
        
        
        
        scoreValue = scnScene.rootNode.childNode(withName: "scoreValueText", recursively: true)!
        scoreValueText = scoreValue.geometry as? SCNText
        
        scoreSign = scnScene.rootNode.childNode(withName: "scoreSign", recursively: true)!
        let scoreSignText = scoreSign.geometry as? SCNText
        scoreSignText?.font = UIFont.systemFont(ofSize: 24, weight: .black)
        
        scoreBillboard = scnScene.rootNode.childNode(withName: "ScoreBillboard", recursively: true)!
        
        heart = scnScene.rootNode.childNode(withName: "Heart", recursively: true)!
        
        holesLightsNode = scnScene.rootNode.childNode(withName: "holesLights", recursively: true)!
        missedLight = scnScene.rootNode.childNode(withName: "missedLight", recursively: true)!
        
        verticalCameraNode = scnScene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        
        HUD = scnScene.rootNode.childNode(withName: "HUD", recursively: true)!
        
        
        heartInitialScale = CGFloat(heart.scale.x)
        
        /*
        let topBillboardLightsNode = scnScene.rootNode.childNode(withName: "LightsTop", recursively: true)
        let bottomBillboardLightsNode = scnScene.rootNode.childNode(withName: "LightsBottom", recursively: true)!
        
        for bulbNodeIndex in 1...5 {
            print(bulbNodeIndex)
            if let bulbNode = topBillboardLightsNode!.childNode(withName: "sphere\(bulbNodeIndex)", recursively: true) {
                topBillboardLights.append(bulbNode)
            }
 
            bottomBillboardLights.append(bottomBillboardLightsNode.childNode(withName: "sphere\(bulbNodeIndex)", recursively: true)!)
        }
        */
        
        /*
         horizontalCameraNode = scnScene.rootNode.childNode(withName: "HorizontalCamera", recursively: true)!
         
         ballNode = scnScene.rootNode.childNode(withName: "Ball", recursively: true)!
         paddleNode = scnScene.rootNode.childNode(withName: "Paddle", recursively: true)!
         */
    }
    
    //DA RIMUOVERE
    @objc func lightsBlink() {
        let x = topBillboardLights[0].geometry?.materials.count
        print(x)
        for bulbNodeIndex in 0...2 {
            bottomBillboardLights[bulbNodeIndex].geometry?.firstMaterial = bottomBillboardLights[bulbNodeIndex].geometry?.materials[x! - 1]
        }
    }
    
    func restartGame() {
        lostScreenisShowed = true
        gameOverLabel.isHidden = false
        //prevents extra missed lights from showing
        missedLight.isHidden = true
        for position in self.spawnPositions {
            //light.clone
            //light.addtoNode
            //light.position = position
            //light.color = random()
        }
        
        lives = 5
        updateLives(byAmount: nil)
        
        
        score = 0
        scoreUpdate(stickPressed: nil)
        
        gameOverLabel.runAction(blink, completionHandler: {
            self.gameOverLabel.isHidden = true
            
            self.lostScreenisShowed = false
            
            
            self.missedLight.isHidden = false
            
            /*
             for light in self.holesLightsNode.childNodes {
             //removeFromParentNode()
             }
             */
        })
        
    }
    
    func hideNode(node: SCNNode) {
        node.opacity = 0
        availableSticks.append(node)
    }
    
    func spawnNode(node: SCNNode) -> SCNNode {
        var index = 0
        for stick in availableSticks {
            index += 1
            print(getFieldFromNodeName(node: stick, field: .name))
            print(node.name!)
            if (getFieldFromNodeName(node: stick, field: .name) == node.name!) {
                availableSticks.remove(at: index)
                stick.opacity = 1
                return stick
            }
        }
        return node.clone()
    }
    
    func setupActions() {
        
        let fadeIn = SCNAction.fadeIn(duration: 0.3)
        //fadeIn.timingMode = .easeOut
        let fadeOut = SCNAction.fadeOut(duration: 0.3)
        let stayStill = SCNAction.wait(duration: 4)
        blink = SCNAction.sequence([fadeIn, fadeOut, fadeIn, fadeOut, fadeIn, fadeOut, stayStill])
        
        let lightUp = SCNAction.fadeOpacity(to: 0.5, duration: 0.3)
        let lightOut = SCNAction.fadeOut(duration: 0.3)
        lightBeam = SCNAction.sequence([lightUp, lightOut])
        
        let goUpAction = SCNAction.moveBy(x: 0, y: 1.5, z: 0, duration: duration * 0.5)
        let goDownAction = SCNAction.moveBy(x: 0, y: -2.3, z: 0, duration: duration * 0.5)
        goUpAction.timingMode = .easeOut
        goDownAction.timingMode = .easeIn
        bounceAction = SCNAction.sequence([goUpAction, goDownAction])
        
        rotateAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 5))
        
        let left = SCNAction.move(by: SCNVector3(x: -0.05, y: 0.0, z: 0.0), duration: 0.1)
        let right = SCNAction.move(by: SCNVector3(x: 0.05, y: 0.0, z: 0.0), duration: 0.1)
        let up = SCNAction.move(by: SCNVector3(x: 0.0, y: 0.05, z: 0.0), duration: 0.1)
        let down = SCNAction.move(by: SCNVector3(x: 0.0, y: -0.05, z: 0.0), duration: 0.1)
        
       shakeAction = (SCNAction.sequence([
            left, up, down, right, left, right, down, up, right, down, left, up]))
        
        let enlarge = SCNAction.scale(by: 1.1, duration: 0.2)
        enlarge.timingMode = .easeOut
        let shrink = SCNAction.scale(by: 0.9, duration: 0.2)
        pulseAction = SCNAction.sequence([enlarge, shrink])
        pulseForeverAction = SCNAction.repeatForever(pulseAction)
        
        //let lightsBlinkTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameViewController.lightsBlink), userInfo: nil, repeats: true)

        
    }
    
    private func spawnStick() {
        
        
        //EnemyNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        
        
        //Calculates a random index for the next enemy to be spawned
        if let randomPositionIndex = availablePositions.randomElement() {
            //Checks if there is already a spawned enemy in that position, if not one is spawned
            //PERCHE != -1?????
            if randomPositionIndex != -1 {
                var childEnemyNode:SCNNode
                //let sortedEnemy = EnemyType.random().rawValue
                
                switch EnemyType.random() {
                case .finger:
                    childEnemyNode = spawnNode(node: fingerNode)
                case .paw:
                    childEnemyNode = spawnNode(node: pawNode)
                case .wurstel:
                    childEnemyNode = spawnNode(node: wurstelNode)
                case .spike:
                    childEnemyNode = spawnNode(node: spikeNode)
                case .panda:
                    childEnemyNode = spawnNode(node: pandaNode)
                case .bear:
                    childEnemyNode = spawnNode(node: bearNode)
                }
                childEnemyNode.worldPosition = spawnPositions[randomPositionIndex]
                childEnemyNode.name!.append(" \(randomPositionIndex)")
                spawnedEnemiesNode.addChildNode(childEnemyNode)
                childEnemyNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat.random(in: 0...360), z: 0, duration: 0.0))
                childEnemyNode.runAction(bounceAction)
                childEnemyNode.runAction(rotateAction)
                //Sets the current spawn position as occupied
                availablePositions[randomPositionIndex] = -1
            }
        }
        
    }
    
    func checkMissed() {
        for node in spawnedEnemiesNode.childNodes {
            if (node.position.y < 0) {
                //lives.removeFirst()
                
                if (!lostScreenisShowed && getFieldFromNodeName(node: node, field: .name) != "spike") {
                    
                }
                
                
                if let positionNameField = getFieldFromNodeName(node: node, field: .spawnPosition) {
                    if let positionIndex = Int(positionNameField) {
                        if (!lostScreenisShowed && getFieldFromNodeName(node: node, field: .name) != "spike") {
                            
                            updateLives(byAmount: -1)
                            //TODO show red light from hole
                            let mL = missedLight.clone()
                            mL.position = spawnPositions[positionIndex]
                            holesLightsNode.addChildNode(mL)
                            
                            mL.runAction(lightBeam) {
                                mL.removeFromParentNode()
                            }
                        }
                        availablePositions[positionIndex] = positionIndex
                    }
                }
                hideNode(node: node)
                
                /*
                if (lives < 1) {
                    restartGame()
                }
                if (lives > 0 ) {
                    livesLabelText.string = String(lives)
                }
                */
            }
        }
    }
    
    func getFieldFromNodeName(node: SCNNode, field: NodeNameField) -> String? {
        switch field {
        case .name:
            if let firstNameField = node.name!.components(separatedBy: " ").first {
                return firstNameField
            } else {
                print("The node \"\(node.name!)\" has an invalid name")
                return nil
            }
        case .spawnPosition:
            if let lastNameField = node.name!.components(separatedBy: " ").last {
                return lastNameField
            } else {
                print("The node \"\(node.name!)\" has an invalid name")
                return nil
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let touchLocation = touch?.location(in: scnView) {
            let nodesHitten = scnView.hitTest(touchLocation, options: [SCNHitTestOption.categoryBitMask : 2])
            
            if let nearestNodeHit = nodesHitten.first {
                if(gameState == .playing) {
                    handleTouchFor(node: nearestNodeHit.node)
                }
            }
        }
    }
    
    private func handleTouchFor(node: SCNNode) {
        print("pressed: " + node.name! + ", parent: " + (node.parent?.name)!)
        if (node.parent == spawnedEnemiesNode) {
            
            
            // get its material
            let material = node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.1
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
                if let positionNameField = self.getFieldFromNodeName(node: node, field: .spawnPosition) {
                    if let positionIndex = Int(positionNameField) {
                        self.availablePositions[positionIndex] = positionIndex
                    }
                }
                node.removeFromParentNode()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
            
            scoreUpdate(stickPressed: getFieldFromNodeName(node: node, field: .name))
            
        }
    }
    func updateLives(byAmount: Int?) {
        if let amount = byAmount {
            lives += amount
            if (amount > 0) {
                
            } else if (amount < 0) {
                heart.runAction(pulseAction)
                verticalCameraNode.runAction(shakeAction)
            }
        }

        if (lives == 1) {
            heart.runAction(pulseForeverAction)
        }
        if (lives < 1) {
            heart.removeAllActions()
            heart.runAction(SCNAction.scale(to: heartInitialScale, duration: 0.2))
            restartGame()
        } else {
            livesLeftLabelText.string = String(lives)
        }
    }
    
    func scoreUpdate(stickPressed: String?) {
        
        if let stickName = stickPressed {
            switch stickName {
            case "bear":
                score = score + 1
                scoreBillboard.runAction(pulseAction)
            case "panda":
                score = score + 1
                scoreBillboard.runAction(pulseAction)
            case "spike":
                updateLives(byAmount: -1)
                heart.runAction(pulseAction)
            default:
                break
            }
        }
        
        scoreString = String(score)
        
        digitsToAdd = 5 - scoreString.count
        if (digitsToAdd > 0) {
            digitsString = String(repeating: "0", count: digitsToAdd)
            scoreValueText.string = digitsString + scoreString
        } else {
            scoreString.removeLast()
            scoreValueText.string = scoreString
        }
        
        
    }
    
    /*
     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
     let deviceOrientation = UIDevice.current.orientation
     switch deviceOrientation {
     case .portrait:
     scnView.pointOfView = verticalCameraNode
     default:
     scnView.pointOfView = horizontalCameraNode
     }
     
     }
     */
    
}

public enum GameStateType {
    case playing
    case splashScreen
    case gameOver
}

public enum NodeNameField {
    case name
    case spawnPosition
}


extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard gameState == .playing else {
            return
        }
        
        HUD.constraints = [SCNBillboardConstraint()]
        
        if (time > spawnTime && !lostScreenisShowed) {
            spawnStick()
            spawnTime = time + TimeInterval(Float.random(in: 0.2 ... 1))
        }
        
        checkMissed()
        //cleanScene()
    }
}
