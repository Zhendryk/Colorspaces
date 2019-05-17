//
//  CGFloat+mod.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//
infix operator &/
infix operator %

public extension CGFloat {

    /// The modulus operator. Works for both positive and negative numbers.
    ///
    /// - Parameters:
    ///   - lhs: The left hand side of the equation, this will be operated on.
    ///   - rhs: The number to mod the left hand side by.
    /// - Returns: The remainder when lhs is modded by rhs.
    static func %(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
        if lhs < 0 {
            return rhs * (1 + (lhs / rhs))
        } else {
            return lhs - (rhs * CGFloat(Int(lhs / rhs)))
        }
    }

    /// The overflow division operator. Divides the left hand side by the right hand side and handles overflows by returning 0.
    ///
    /// - Parameters:
    ///   - lhs: The left hand side of the equation, the dividend.
    ///   - rhs: The right hand side of the equation, the divisor.
    /// - Returns: The value of lhs / rhs, while handling overflows.
    static func &/(lhs: CGFloat, rhs: CGFloat) -> CGFloat {
        if rhs == 0 { return 0 }
        return lhs/rhs
    }


    /// Returns self as a value between
    var normalized: CGFloat {
        if self < 1 {
            return (self + 1)
        } else if self > 1 {
            return (self - 1)
        } else {
            return self
        }
    }
}
