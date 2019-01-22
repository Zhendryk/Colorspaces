//
//  HSBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public struct HSBColor {
    
    /// The hue of this HSB color (0 - 360).
    public let hue: Int
    
    /// The saturation of this HSB color (0 - 100% == 0.0 - 1.0).
    public let saturation: Float
    
    /// The brightness of this HSB color (0 - 100% == 0.0 - 1.0).
    public let brightness: Float
    
    /// Initializes a new HSBColor object with the given hue, saturation and brightness.
    ///
    /// - Parameters:
    ///   - h: The hue (0 - 360).
    ///   - s: The saturation (0.0 - 1.0).
    ///   - b: The brightness (0.0 - 1.0).
    public init(_ h: Int, _ s: Float, _ b: Float) {
        self.hue = h
        self.saturation = s
        self.brightness = b
    }
    
    /// The UIColor equivalent of this HSB color.
    public var uiColor: UIColor {
        return rgb.uiColor
    }
    
    /// The hexadecimal string representation of this HSB color.
    public var hex: String {
        return rgb.hex
    }

    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this HSB color.
    ///
    /// - Returns: The RGB equivalent of this HSB color.
    public var rgb: RGBColor {
        let chroma = brightness * saturation
        let x = chroma * (1 - abs((Float(hue) / 60).mod(by: 2) - 1))
        let m = brightness - chroma
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0
        if (hue >= 0 || hue == 360) && hue < 60 {
            r = chroma
            g = x
        }
        else if hue >= 60 && hue < 120 {
            r = x
            g = chroma
        }
        else if hue >= 120 && hue < 180 {
            g = chroma
            b = x
        }
        else if hue >= 180 && hue < 240 {
            g = x
            b = chroma
        }
        else if hue >= 240 && hue < 300 {
            r = x
            b = chroma
        }
        else if hue >= 300 && hue < 360 {
            r = chroma
            b = x
        }
        return RGBColor(Int((r + m)*255), Int((g + m)*255), Int((b + m)*255))
    }
}
