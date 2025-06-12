//
//  EnemyType.swift
//  Cat whack a mole
//
//  Created by Gianluca Rossi on 16/03/2019.
//  Copyright © 2019 Gianluca Rossi. All rights reserved.
//

import Foundation

enum EnemyType: Int {
    case bear = 0
    case panda
    case penguin
    case spike
    
    static func random() -> EnemyType {
        let maxValue = spike.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return EnemyType(rawValue: Int(rand))!
    }
}
