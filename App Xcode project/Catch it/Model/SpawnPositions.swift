//
//  File.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 25/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import Foundation
import SceneKit

public class SpawnPositions {

    private let spawnPositions = [SCNVector3(-1.516, 0, -5.16),
                          SCNVector3(0, 0, -5.16),
                          SCNVector3(1.516, 0, -5.16),
                          SCNVector3(-1.516, 0, -2.05),
                          SCNVector3(0, 0, -2.05),
                          SCNVector3(1.516, 0, -2.05),
                          SCNVector3(-1.516, 0, 1.064),
                          SCNVector3(0, 0, 1.064),
                          SCNVector3(1.516, 0, 1.064)]
    
    public func getSpawnPositions() -> [SCNVector3] {
        return spawnPositions
    }
    
}
