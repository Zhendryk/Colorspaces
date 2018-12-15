//
//  CMYKColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public struct CMYKColor {
    public let cyan: Int
    public let magenta: Int
    public let yellow: Int
    public let black: Int
    
    public init(_ c: Int, _ m: Int, _ y: Int, _ k: Int) {
        self.cyan = c
        self.magenta = m
        self.yellow = y
        self.black = k
    }
    
    /// The UIColor equivalent of this CMYK color.
    public var uiColor: UIColor {
        let rgb = toRGB()
        return UIColor(red: CGFloat(rgb.red), green: CGFloat(rgb.green), blue: CGFloat(rgb.blue), alpha: 1.0)
    }
    
    /// The hexadecimal string representation of this CMYK color.
    public var hex: String {
        let rgb = toRGB()
        return "#" + String(rgb.red, radix: 16) + String(rgb.green, radix: 16) + String(rgb.blue, radix: 16)
    }
    
    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this CMYK color.
    ///
    /// - Returns: The RGB equivalent of this CMYK color.
    public func toRGB() -> RGBColor {
        let red = 255.0 * (1.0 - Float(cyan)) * (1.0 - Float(black))
        let green = 255.0 * (1.0 - Float(magenta)) * (1.0 - Float(black))
        let blue = 255.0 * (1.0 - Float(yellow)) * (1.0 - Float(black))
        return RGBColor(Int(red), Int(green), Int(blue))
    }
}
