//
//  HelperFunctions.swift
//  Starfield
//
//  Created by Bob Voorneveld on 16-01-18.
//  Copyright © 2018 Bob Voorneveld. All rights reserved.
//

import SpriteKit

func map(_ value: CGFloat, _ low1: CGFloat, _ high1: CGFloat, _ low2: CGFloat, _ high2: CGFloat) -> CGFloat {
    return low2 + (high2 - low2) * (value - low1) / (high1 - low1)
}
