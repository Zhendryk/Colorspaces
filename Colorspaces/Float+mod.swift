//
//  Float+mod.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public extension Float {
    
    /// The modulus operator for floating point numbers. (Works for both positive and negative).
    ///
    /// - Parameter n: The number to modulo by.
    /// - Returns: The remainder after the modulus by n.
    func mod(by n: Float) -> Float {
        if self < 0 {
            return n * (1 + (self / n))
        }
        else {
            return self - (n * Float(Int(self/n)))
        }
    }

    /// Returns 0.0 in the event this number is NaN. Returns itself otherwise.
    ///
    /// - Returns: 0.0 if NaN, itself otherwise.
    func nanSafe() -> Float {
        return self.isNaN ? 0.0 : self
    }
}
