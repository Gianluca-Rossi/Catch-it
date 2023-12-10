//
//  ResourceLoader.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 23/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import Foundation
import SceneKit

public class ResourceLoader {
    
    static let sharedInstance = ResourceLoader()
    
    var sounds: [String: SCNAudioSource] = [:]
    
    func loadSound(name:String, fileNamed:String) {
        if let sound = SCNAudioSource(fileNamed: fileNamed) {
            sound.isPositional = false
            sound.volume = 1
            sound.load()
            sounds[name] = sound
        }
    }
    
    func playSound(node:SCNNode, name:String) {
        let sound = sounds[name]
        node.runAction(SCNAction.playAudio(sound!, waitForCompletion: false))
    }
}
