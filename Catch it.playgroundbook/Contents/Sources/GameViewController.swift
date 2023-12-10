//
//  GameViewController.swift
//  Catch it
//
//  Created by Gianluca Rossi on 16/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import UIKit
import SceneKit

public class GameViewController: UIViewController {
    
    var scnView = SCNView()
    
    var gameScene: SCNScene!
    var sticksScene : SCNScene!
    
    var verticalCameraNode: SCNNode!
    var spawnedEnemiesNode: SCNNode!
    var spikeNode: SCNNode!
    var pandaNode: SCNNode!
    var bearNode: SCNNode!
    var penguinNode: SCNNode!
    var holesLightsNode: SCNNode!
    var missedLight: SCNNode!
    var livesNode: SCNNode!
    var livesLabel: SCNNode!
    var livesLeftLabel: SCNNode!
    var gameOverLabel: SCNNode!
    var levelValue: SCNNode!
    var levelNode: SCNNode!
    var heart: SCNNode!
    var scoreBillboard: SCNNode!
    var scoreValue: SCNNode!
    var scoreNode: SCNNode!
    var scoreSign: SCNNode!
    var tapToStart: SCNNode!
    var HUD: SCNNode!
    var splashHUD: SCNNode!
    var victoryHands: SCNNode!
    var newBest: SCNNode!
    var bestNode: SCNNode!
    var highScoreValue: SCNNode!
    var block: SCNNode!
    var blockWithHole: SCNNode!
    
    
    var heartInitialScale: CGFloat!
    
    var bottomBillboardLights : [SCNNode] = []
    var topBillboardLights : [SCNNode] = []
    
    var livesLeftLabelText: SCNText!
    var gameOverLabelText: SCNText!
    var scoreValueText: SCNText!
    var levelValueText: SCNText!
    var highScoreValueText: SCNText!
    
    var spawnTime: TimeInterval = 0
    var scoreNodeInitialPosition : SCNVector3!
    var scoreBillboardInitialEulerAngles : SCNVector3!
    var spawnPositions : [SCNVector3]!
    var availablePositions : [Int] = []
    
    var gameState = GameStateType.splashScreen
    
    var resourceLoader = ResourceLoader.sharedInstance
    
    var duration = 1.5
    var lives = 5
    var score = 0
    var highScore = 0
    var level = 1
    var randomPositionIndex = 0
    var maxDelay : Float = 1.0
    var digitsToAdd = 0
    var digitsString = ""
    var scoreString = ""
    
    var lostScreenisShowed = false
    
    var goUpAction : SCNAction!
    var goDownAction : SCNAction!
    var bounceAction : SCNAction!
    var fadeIn : SCNAction!
    var fadeOut : SCNAction!
    var stayStill : SCNAction!
    var blink : SCNAction!
    var lightBeam : SCNAction!
    var rotateAction : SCNAction!
    var shakeAction : SCNAction!
    var pulseAction : SCNAction!
    var pulseForeverAction : SCNAction!
    
    var gameMusic = SCNAudioSource()
    var menuMusic = SCNAudioSource()
    
    var currentTheme = Themes.ice
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupNodes()
        setupText()
        setupSounds()
        setupPositions()
        setupActions()
        
        startSplashScreen()
    }
    
    private func setupView() {
        
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scnView)
        scnView.frame = view.bounds
        scnView.delegate = self
        scnView.isPlaying = true
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
        if let scnScene = SCNScene(named: "art.scnassets/Game.scn") {
            gameScene = scnScene
            scnView.scene = gameScene
        } else { fatalError("Unable to load game scene file.") }
        
        if let scnScene = SCNScene(named: "art.scnassets/sticks.scn") {
            sticksScene = scnScene
        } else { fatalError("Unable to load sticks scene file.") }
    }
    
    func playMatchMusic() {
        for player in gameScene.rootNode.audioPlayers {
            if !(player.audioSource == gameMusic) {
                gameScene.rootNode.removeAllAudioPlayers()
            } else {
                return
            }
        }
        let gameMusicPlayer = SCNAudioPlayer(source: gameMusic)
        gameScene.rootNode.addAudioPlayer(gameMusicPlayer)
    }
    
    func playMenuMusic() {
        for player in gameScene.rootNode.audioPlayers {
            if !(player.audioSource == menuMusic) {
                gameScene.rootNode.removeAllAudioPlayers()
            } else {
                return
            }
        }
        let gameMusicPlayer = SCNAudioPlayer(source: menuMusic)
        gameScene.rootNode.addAudioPlayer(gameMusicPlayer)
    }
    
    func setupSounds() {
        
        gameMusic = SCNAudioSource(fileNamed: "art.scnassets/Audio/gameMusic.m4a")!
        gameMusic.volume = 0.3
        gameMusic.loops = true
        gameMusic.shouldStream = true
        gameMusic.isPositional = false
        
        menuMusic = SCNAudioSource(fileNamed: "art.scnassets/Audio/menuMusic.m4a")!
        menuMusic.volume = 0.3
        menuMusic.loops = true
        menuMusic.shouldStream = true
        menuMusic.isPositional = false
        
        resourceLoader.loadSound(name: "buttonPressed", fileNamed: "art.scnassets/Audio/buttonPressed.m4a")
        resourceLoader.loadSound(name: "miss", fileNamed: "art.scnassets/Audio/miss.m4a")
        resourceLoader.loadSound(name: "gameOver", fileNamed: "art.scnassets/Audio/gameOver.m4a")
        resourceLoader.loadSound(name: "levelUp", fileNamed: "art.scnassets/Audio/levelUp.m4a")
        resourceLoader.loadSound(name: "highScore", fileNamed: "art.scnassets/Audio/highScore.m4a")
        resourceLoader.loadSound(name: "spikeTapped", fileNamed: "art.scnassets/Audio/spikeTapped.m4a")
        resourceLoader.loadSound(name: "stickSpawned", fileNamed: "art.scnassets/Audio/stickSpawned.m4a")
        resourceLoader.loadSound(name: "stickCatched", fileNamed: "art.scnassets/Audio/stickCatched.m4a")
    }
    
    func setupPositions() {
        spawnPositions = [SCNVector3(-1.516, 0, -5.16),
                          SCNVector3(0, 0, -5.16),
                          SCNVector3(1.516, 0, -5.16),
                          SCNVector3(-1.516, 0, -2.05),
                          SCNVector3(0, 0, -2.05),
                          SCNVector3(1.516, 0, -2.05),
                          SCNVector3(-1.516, 0, 1.064),
                          SCNVector3(0, 0, 1.064),
                          SCNVector3(1.516, 0, 1.064)]
        
        //Creates an array with the available spawn positions
        availablePositions.reserveCapacity(spawnPositions.count)
        for i in 0..<spawnPositions.count {
            availablePositions.append(i)
        }
        
        heartInitialScale = CGFloat(heart.scale.x)
        scoreNodeInitialPosition = scoreNode.position
        scoreBillboardInitialEulerAngles = scoreBillboard.eulerAngles
    }
    
    func setupText() {
        let livesLabelText = livesLabel.geometry as? SCNText
        livesLabelText?.font = UIFont.systemFont(ofSize: 24, weight: .black).setItalicFnc()
        livesLeftLabelText = livesLeftLabel.geometry as? SCNText
        livesLeftLabelText.font = UIFont.systemFont(ofSize: 36, weight: .black).setItalicFnc()
        gameOverLabelText = gameOverLabel.geometry as? SCNText
        gameOverLabelText.font = UIFont.systemFont(ofSize: 14, weight: .black).setItalicFnc()
        let tapToStartText = tapToStart.geometry as? SCNText
        tapToStartText?.font = UIFont.systemFont(ofSize: 9, weight: .black).setItalicFnc()
        let bestNodeText = bestNode.geometry as? SCNText
        bestNodeText!.font = UIFont.systemFont(ofSize: 9, weight: .black).setItalicFnc()
        highScoreValueText = highScoreValue.geometry as? SCNText
        highScoreValueText.font = UIFont.systemFont(ofSize: 9, weight: .black)
        scoreValueText = scoreValue.geometry as? SCNText
        scoreValueText.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        let scoreSignText = scoreSign.geometry as? SCNText
        scoreSignText?.font = UIFont.systemFont(ofSize: 24, weight: .black).setItalicFnc()
        let newBestText = newBest.geometry as? SCNText
        newBestText!.font = UIFont.systemFont(ofSize: 7, weight: .black).setItalicFnc()
        let levelNodeText = levelNode.geometry as? SCNText
        levelNodeText!.font = UIFont.systemFont(ofSize: 24, weight: .black).setItalicFnc()
        levelValueText = levelValue.geometry as? SCNText
        levelValueText.font = UIFont.systemFont(ofSize: 24, weight: .black).setItalicFnc()
    }
    
    func setupNodes() {
        spikeNode = sticksScene.rootNode.childNode(withName: "spike", recursively: true)!
        pandaNode = sticksScene.rootNode.childNode(withName: "panda", recursively: true)!
        bearNode = sticksScene.rootNode.childNode(withName: "bear", recursively: true)!
        penguinNode = sticksScene.rootNode.childNode(withName: "penguin", recursively: true)!
        spawnedEnemiesNode = gameScene.rootNode.childNode(withName: "SpawnedSticks", recursively: true)!
        livesNode = gameScene.rootNode.childNode(withName: "Lives", recursively: true)!
        livesLabel = gameScene.rootNode.childNode(withName: "LivesText", recursively: true)!
        livesLeftLabel = gameScene.rootNode.childNode(withName: "LivesLeftText", recursively: true)!
        gameOverLabel = gameScene.rootNode.childNode(withName: "GameOverText", recursively: true)!
        tapToStart = gameScene.rootNode.childNode(withName: "tapToStartText", recursively: true)!
        bestNode = gameScene.rootNode.childNode(withName: "bestText", recursively: true)!
        highScoreValue = gameScene.rootNode.childNode(withName: "highScoreValue", recursively: true)!
        scoreValue = gameScene.rootNode.childNode(withName: "scoreValueText", recursively: true)!
        scoreSign = gameScene.rootNode.childNode(withName: "scoreSign", recursively: true)!
        scoreBillboard = gameScene.rootNode.childNode(withName: "ScoreBillboard", recursively: true)!
        scoreNode = gameScene.rootNode.childNode(withName: "Score", recursively: true)!
        victoryHands = gameScene.rootNode.childNode(withName: "victoryHands", recursively: true)!
        newBest = gameScene.rootNode.childNode(withName: "newBestText", recursively: true)!
        levelNode = gameScene.rootNode.childNode(withName: "Level", recursively: true)!
        levelValue = gameScene.rootNode.childNode(withName: "LevelValue", recursively: true)!
        heart = gameScene.rootNode.childNode(withName: "Heart", recursively: true)!
        holesLightsNode = gameScene.rootNode.childNode(withName: "holesLights", recursively: true)!
        missedLight = gameScene.rootNode.childNode(withName: "missedLight", recursively: true)!
        verticalCameraNode = gameScene.rootNode.childNode(withName: "VerticalCamera", recursively: true)!
        scnView.pointOfView = verticalCameraNode
        HUD = gameScene.rootNode.childNode(withName: "HUD", recursively: true)!
        splashHUD = gameScene.rootNode.childNode(withName: "splashHUD", recursively: true)!
        block = gameScene.rootNode.childNode(withName: "iceBlock", recursively: true)!
        blockWithHole = gameScene.rootNode.childNode(withName: "iceBlockWithHole", recursively: true)!
    }
    
    func setupActions() {
        fadeIn = SCNAction.fadeIn(duration: 0.3)
        fadeOut = SCNAction.fadeOut(duration: 0.3)
        stayStill = SCNAction.wait(duration: 4)
        blink = SCNAction.sequence([fadeIn, fadeOut, fadeIn, fadeOut, fadeIn, fadeOut, stayStill])
        
        let lightUp = SCNAction.fadeOpacity(to: 0.5, duration: 0.3)
        let lightOut = SCNAction.fadeOut(duration: 0.3)
        lightBeam = SCNAction.sequence([lightUp, lightOut])
        
        goUpAction = SCNAction.moveBy(x: 0, y: 3, z: 0, duration: duration)
        goDownAction = SCNAction.moveBy(x: 0, y: -3.8, z: 0, duration: duration)
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
        let shrink = SCNAction.scale(by: 0.909, duration: 0.2)
        pulseAction = SCNAction.sequence([enlarge, shrink])
        pulseForeverAction = SCNAction.repeatForever(pulseAction)
    }
    
    private func spawnShape() {
        var childEnemyNode:SCNNode
        
        switch EnemyType.random() {
        case .spike:
            childEnemyNode = spikeNode.clone()
            childEnemyNode.name = "spike"
        case .panda:
            childEnemyNode = pandaNode.clone()
            childEnemyNode.name = "panda"
        case .bear:
            childEnemyNode = bearNode.clone()
            childEnemyNode.name = "bear"
        case .penguin:
            childEnemyNode = penguinNode.clone()
            childEnemyNode.name = "penguin"
        }
        
        //Calculates a random index for the next enemy to be spawned
        if let randomPositionIndex = availablePositions.randomElement() {
            //Checks if there is already a spawned enemy in that position, if not one is spawned
            if randomPositionIndex != -1 {
                childEnemyNode.worldPosition = spawnPositions[randomPositionIndex]
                //saves the spawn position in the name of the node
                childEnemyNode.name!.append(" \(randomPositionIndex)")
                
                spawnedEnemiesNode.addChildNode(childEnemyNode)
                
                childEnemyNode.runAction(SCNAction.rotateBy(x: 0, y: CGFloat.random(in: 0...360), z: 0, duration: 0.0))
                childEnemyNode.runAction(bounceAction)
                childEnemyNode.runAction(rotateAction)
                
                //Sets the current spawn position as occupied
                availablePositions[randomPositionIndex] = -1
                
                //Waits for the stick to jump out of the box to play the spawn sound
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                    self.resourceLoader.playSound(node: self.scoreBillboard, name: "stickSpawned")
                }
            }
        }
        
    }
    
    func checkMissed() {
        for node in spawnedEnemiesNode.childNodes {
            if (node.position.y < -0.2) {
                if let positionNameField = getFieldFromNodeName(node: node, field: .spawnPosition) {
                    if let positionIndex = Int(positionNameField) {
                        if (gameState == .playing && getFieldFromNodeName(node: node, field: .name) != "spike") {
                            resourceLoader.playSound(node: scoreBillboard, name: "miss")
                            updateLives(byAmount: -1)
                            
                            //Show red light from hole
                            let redLight = missedLight.clone()
                            var redLightPosition = spawnPositions[positionIndex]
                            redLightPosition.y = 4.43
                            redLight.position = redLightPosition
                            holesLightsNode.addChildNode(redLight)
                            redLight.runAction(lightBeam, completionHandler: {
                                redLight.removeFromParentNode()
                            })
                        }
                        //Sets the node spawn position as available
                        availablePositions[positionIndex] = positionIndex
                    }
                }
                node.removeFromParentNode()
                
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
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if gameState == .splashScreen {
            startGame()
            resourceLoader.playSound(node: scoreBillboard, name: "buttonPressed")
            return
        } else if gameState == .gameOver {
            restartGame()
            resourceLoader.playSound(node: scoreBillboard, name: "buttonPressed")
            return
        }
        
        if let touchLocation = touch?.location(in: scnView) {
            let nodesHitten = scnView.hitTest(touchLocation, options: [SCNHitTestOption.categoryBitMask : 2])
            if let nearestNodeHit = nodesHitten.first {
                if(gameState == .playing) {
                    handleTouchFor(node: nearestNodeHit.node)
                }
            }
        }
    }
    
    
    func startSplashScreen() {
        playMenuMusic()
        gameState = .splashScreen
        HUD.isHidden = true
        HUD.opacity = 0
        splashHUD.isHidden = false
        splashHUD.runAction(SCNAction.fadeIn(duration: 0.8))
        tapToStart.parent!.runAction(pulseForeverAction)
    }
    
    func startGame() {
        playMatchMusic()
        splashHUD.isHidden = true
        splashHUD.opacity = 0
        tapToStart.parent!.removeAllActions()
        tapToStart.parent!.runAction(SCNAction.scale(to: 1, duration: 0))
        HUD.isHidden = false
        levelNode.isHidden = false
        HUD.runAction(SCNAction.fadeIn(duration: 0.8))
        levelNode.runAction(SCNAction.sequence([stayStill, fadeOut]), completionHandler: {
            self.levelNode.isHidden = true
            self.levelNode.opacity = 1
        })
        gameState = .playing
    }
    
    func startGameOverScreen() {
        playMenuMusic()
        gameState = .gameOver
        
        //Prevents extra missed lights from showing
        missedLight.isHidden = true
        
        livesNode.runAction(SCNAction.fadeOut(duration: 0.8))
        scoreNode.runAction(SCNAction.move(to: SCNVector3(2.366, -4.403, 5.5), duration: 1))
        scoreBillboard.runAction(SCNAction.rotateTo(x: 0.15, y: 0, z: 0, duration: 1))
        
        if (score > highScore) {
            resourceLoader.playSound(node: scoreBillboard, name: "highScore")
            bestNode.isHidden = false
            bestNode.runAction(fadeIn)
            highScore = score
            highScoreValueText.string = scoreValueText.string
            victoryHands.isHidden = false
            victoryHands.runAction(SCNAction.fadeIn(duration: 0.5))
            victoryHands.runAction(SCNAction.scale(to: 2, duration: 0.5))
        } else {
            resourceLoader.playSound(node: scoreBillboard, name: "gameOver")
            gameOverLabel.isHidden = false
            gameOverLabel.runAction(blink, completionHandler: {
                self.gameOverLabel.isHidden = true
            })
            splashHUD.isHidden = false
            splashHUD.runAction(SCNAction.sequence([stayStill, fadeIn]))
            tapToStart.parent!.runAction(pulseForeverAction)
        }
    }
    
    func restartGame() {
        playMatchMusic()
        //Prevents animation from bugging when tapping ultra fast
        if scoreNode.hasActions {
            scoreNode.removeAllActions()
            scoreBillboard.removeAllActions()
        }
        
        scoreNode.runAction(SCNAction.move(to: scoreNodeInitialPosition, duration: 0.8))
        scoreBillboard.runAction(SCNAction.rotateTo(x: CGFloat(scoreBillboardInitialEulerAngles!.x),
                                                    y: CGFloat(scoreBillboardInitialEulerAngles!.y),
                                                    z: CGFloat(scoreBillboardInitialEulerAngles!.z), duration: 1))
        livesNode.runAction(SCNAction.fadeIn(duration: 0.8))
        splashHUD.isHidden = true
        splashHUD.opacity = 0
        tapToStart.parent!.removeAllActions()
        tapToStart.parent!.runAction(SCNAction.scale(to: 1, duration: 0))
        
        if !victoryHands.isHidden {
            if victoryHands.hasActions {
                //Prevents animation from bugging when tapping ultra fast
                victoryHands.removeAllActions()
            }
            victoryHands.runAction(fadeOut)
            victoryHands.runAction(SCNAction.scale(to: 0.5, duration: 0.3))
        }
        
        lives = 5
        updateLives(byAmount: nil)
        score = 0
        scoreUpdate(stickPressed: nil)
        updateLevel(increase: false)
        missedLight.isHidden = false
        gameState = .playing
    }
    
    func updateLevel(increase: Bool) {
        if increase {
            resourceLoader.playSound(node: scoreBillboard, name: "levelUp")
            level += 1
            switch level {
            case 2:
                duration = 1.0
                maxDelay = 0.9
            case 3:
                duration = 0.8
                maxDelay = 0.7
            default:
                duration = 0.8
                maxDelay = 0.5
            }
        } else {
            level = 1
            maxDelay = 1
            duration = 1.5
        }
        goUpAction.duration = duration
        goDownAction.duration = duration
        bounceAction = SCNAction.sequence([goUpAction, goDownAction])
        
        levelValueText.string = String(level)
        levelNode.isHidden = false
        levelNode.runAction(SCNAction.fadeIn(duration: 0.8))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.levelNode.runAction(SCNAction.fadeOut(duration: 0.8))
        }
    }
    
    func createTapEffect(forNode node: SCNNode) {
        let tapEffect = SCNParticleSystem(named: "tapEffect.scnp", inDirectory: "art.scnassets")!
        let name = getFieldFromNodeName(node: node, field: .name)
        switch name {
        case "bear":
            tapEffect.particleColor = UIColor.brown
        case "panda":
            tapEffect.particleColor = UIColor.white
        case "spike":
            tapEffect.particleColor = UIColor.red
        case "penguin":
            tapEffect.particleColor = hexStringToUIColor(hex: "3C53B0")
        default:
            tapEffect.particleColor = UIColor.white
        }
        let position = node.convertTransform(node.pivot, to: gameScene.rootNode)
        gameScene.addParticleSystem(tapEffect, transform: position)
    }
    
    private func handleTouchFor(node: SCNNode) {
        
        if let nodeParent = node.parent {
            if (nodeParent == spawnedEnemiesNode) {
                
                createTapEffect(forNode: node)
                let stickName = getFieldFromNodeName(node: node, field: .name)
                scoreUpdate(stickPressed: stickName)
                
                //Sets the node spawn position as available
                if let positionNameField = self.getFieldFromNodeName(node: node, field: .spawnPosition) {
                    if let positionIndex = Int(positionNameField) {
                        self.availablePositions[positionIndex] = positionIndex
                    }
                }
                node.removeFromParentNode()
            }
        }
    }
    
    func updateLives(byAmount: Int?) {
        if let amount = byAmount {
            lives += amount
            if (amount < 0) {
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
            startGameOverScreen()
        } else {
            livesLeftLabelText.string = String(lives)
        }
    }
    
    func scoreUpdate(stickPressed: String?) {
        if let stickName = stickPressed {
            switch stickName {
            case "spike":
                updateLives(byAmount: -1)
                heart.runAction(pulseAction)
                resourceLoader.playSound(node: scoreBillboard, name: "spikeTapped")
            default:
                score = score + 1
                scoreBillboard.runAction(pulseAction)
                resourceLoader.playSound(node: scoreBillboard, name: "stickCatched")
            }
        }
        
        scoreString = String(score)
        //Calculates the number of 0 to add in front of the score
        digitsToAdd = 5 - scoreString.count
        if (digitsToAdd > 0) {
            digitsString = String(repeating: "0", count: digitsToAdd)
            scoreValueText.string = digitsString + scoreString
        } else {
            scoreString.removeLast()
            scoreValueText.string = scoreString
        }
        
        if ((score / 30) >= level) {
            updateLevel(increase: true)
        }
    }
    
    public func changeTheme(with themeSelected: Themes) {
        switch themeSelected {
        case .earth:
            if (themeSelected == currentTheme) {
                break
            } else {
                setEarthTheme()
            }
        case .ice:
            if (themeSelected == currentTheme) {
                break
            } else {
                setIceTheme()
            }
        }
    }
    
    func setEarthTheme() {
        for material in (blockWithHole.geometry?.materials)! {
            switch material.name {
            case "Base":
                material.diffuse.contents = hexStringToUIColor(hex: "9C7650")
            case "Lateral":
                material.diffuse.contents = hexStringToUIColor(hex: "AD6909")
            case "Top":
                material.diffuse.contents = hexStringToUIColor(hex: "3A7F26")
            case "Hole":
                material.diffuse.contents = hexStringToUIColor(hex: "7B5C39")
            case "Stalactite":
                material.diffuse.contents = hexStringToUIColor(hex: "D9C08D")
            case "Stone":
                material.diffuse.contents = hexStringToUIColor(hex: "323232")
            default:
                break
            }
        }
        for material in (block.geometry?.materials)! {
            switch material.name {
            case "Base":
                material.diffuse.contents = hexStringToUIColor(hex: "9C7650")
            case "Lateral":
                material.diffuse.contents = hexStringToUIColor(hex: "AD6909")
            case "Top":
                material.diffuse.contents = hexStringToUIColor(hex: "3A7F26")
            case "Stalactite":
                material.diffuse.contents = hexStringToUIColor(hex: "D9C08D")
            case "Stone":
                material.diffuse.contents = hexStringToUIColor(hex: "323232")
            default:
                break
            }
        }
    }
    
    func setIceTheme() {
        for material in (blockWithHole.geometry?.materials)! {
            switch material.name {
            case "Base":
                material.diffuse.contents = hexStringToUIColor(hex: "9CC2CE")
            case "Lateral":
                material.diffuse.contents = hexStringToUIColor(hex: "8CA2B2")
            case "Top":
                material.diffuse.contents = hexStringToUIColor(hex: "CCCCCC")
            case "Hole":
                material.diffuse.contents = hexStringToUIColor(hex: "AFD1E4")
            case "Stalactite":
                material.diffuse.contents = hexStringToUIColor(hex: "CBEBFF")
            case "Stone":
                material.diffuse.contents = hexStringToUIColor(hex: "323232")
            default:
                break
            }
        }
        for material in (block.geometry?.materials)! {
            switch material.name {
            case "Base":
                material.diffuse.contents = hexStringToUIColor(hex: "9CC2CE")
            case "Lateral":
                material.diffuse.contents = hexStringToUIColor(hex: "8CA2B2")
            case "Top":
                material.diffuse.contents = hexStringToUIColor(hex: "CCCCCC")
            case "Stalactite":
                material.diffuse.contents = hexStringToUIColor(hex: "CBEBFF")
            case "Stone":
                material.diffuse.contents = hexStringToUIColor(hex: "323232")
            default:
                break
            }
        }
    }
    
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

public enum Themes {
    case ice
    case earth
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
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard gameState != .splashScreen else {
            return
        }
        
        if (time > spawnTime && gameState == .playing) {
            spawnShape()
            spawnTime = time + TimeInterval(Float.random(in: 0.2 ... maxDelay))
        }
        checkMissed()
    }
}

extension UIFont
{
    func setItalicFnc()-> UIFont
    {
        var fontAtrAry = fontDescriptor.symbolicTraits
        fontAtrAry.insert([.traitItalic])
        let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
        return UIFont(descriptor: fontAtrDetails!, size: 0)
    }
}
