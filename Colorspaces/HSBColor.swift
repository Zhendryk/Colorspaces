//
//  HSBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public struct HSBColor {
    public let hue: Int
    public let saturation: Int
    public let brightness: Int
    
    public init(_ h: Int, _ s: Int, _ b: Int) {
        self.hue = h
        self.saturation = s
        self.brightness = b
    }
    
    /// The UIColor equivalent of this HSB color.
    public var uiColor: UIColor {
        let rgb = toRGB()
        return UIColor(red: CGFloat(rgb.red), green: CGFloat(rgb.green), blue: CGFloat(rgb.blue), alpha: 1.0)
    }
    
    /// The hexadecimal string representation of this HSB color.
    public var hex: String {
        let rgb = toRGB()
        return "#" + String(rgb.red, radix: 16) + String(rgb.green, radix: 16) + String(rgb.blue, radix: 16)
    }
    
    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this HSB color.
    ///
    /// - Returns: The RGB equivalent of this HSB color.
    public func toRGB() -> RGBColor {
        let chroma = Float(brightness * saturation)
        let _h = Float(hue)/Float(60)
        let x = chroma * Float(1 - abs((Int(_h) % 2) - 1))
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0
        if (_h >= 0 || _h == 360) && _h < 60 {
            r = chroma
            g = x
        }
        else if _h >= 60 && _h < 120 {
            r = x
            g = chroma
        }
        else if _h >= 120 && _h < 180 {
            g = chroma
            b = x
        }
        else if _h >= 180 && _h < 240 {
            g = x
            b = chroma
        }
        else if _h >= 240 && _h < 300 {
            r = x
            b = chroma
        }
        else if _h >= 300 && _h < 360 {
            r = chroma
            b = x
        }
        let m = Float(brightness) - chroma
        return RGBColor(Int(r + m), Int(g + m), Int(b + m))
    }
}
