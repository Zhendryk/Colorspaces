//
//  Int+circleBounded.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 5/16/19.
//  Copyright © 2019 Jonathan Bailey. All rights reserved.
//

internal extension Int {

    /// Binds this integer to a value within 0 - 360 degrees.
    var circleBounded: Int {
        get {
            if self > 360 { return self % 360 }
            else if self < 0 {
                var v = self
                while v < 0 {
                    v += 360
                }
                return v % 360
            }
            else { return self }
        }
    }
}
