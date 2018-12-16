//
//  Float+mod.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public extension Float {
    
    /// The modulus operator for floating point numbers. (Works for both positive and negative).
    ///
    /// - Parameter n: The number to modulo by.
    /// - Returns: The remainder after the modulus by n.
    public func mod(by n: Float) -> Float {
        if self < 0 {
            return n * (1 + (self / n))
        }
        else {
            return self - (n * Float(Int(self/n)))
        }
    }
}
