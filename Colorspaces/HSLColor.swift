//
//  HSLColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public struct HSLColor {
    
    /// The hue of this HSLColor (0-360).
    public let hue: Int
    
    /// The saturation of this HSLColor (0 - 100% == 0.0 - 1.0).
    public let saturation: CGFloat
    
    /// The lightness of this HSLColor (0 - 100% == 0.0 - 1.0).
    public let lightness: CGFloat

    /// The alpha of this HSLColor (0.0 - 1.0)
    public let alpha: CGFloat
    
    /// Initializes a new HSLColor object with the given hue, saturation and lightness.
    ///
    /// - Parameters:
    ///   - h: The hue (0 - 360).
    ///   - s: The saturation (0.0 - 1.0).
    ///   - l: The lightness (0.0 - 1.0).
    ///   - a: The alpha (0.0 - 1.0).
    public init(_ h: Int, _ s: CGFloat, _ l: CGFloat, _ a: CGFloat = 1) {
        self.hue = h
        self.saturation = s
        self.lightness = l
        self.alpha = a
    }
    
    /// The UIColor equivalent of this HSLColor.
    public var uiColor: UIColor {
        return rgb.uiColor
    }
    
    /// The hexadecimal string representation of this HSLColor.
    public var hex: String {
        return rgb.hex
    }

    /// Returns a formatted string of this color in the format: "(h: `self.hue`, s: `self.saturation`, l: `self.lightness`, a: `self.alpha`)"
    public var string: String {
        get {
            return "(h: \(hue), s: \(saturation), l: \(lightness), a: \(alpha))"
        }
    }
    
    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this HSLColor.
    ///
    /// - Returns: The RGB equivalent of this HSLColor.
    public var rgb: RGBColor {
        var hCalc = CGFloat(hue)
        if saturation == 0.0 {
            let grayValue = Int(lightness * 255)
            return RGBColor(grayValue, grayValue, grayValue)
        }
        var tmp1: CGFloat
        if lightness < 0.5 {
            tmp1 = lightness * (1 + saturation)
        } else {
            tmp1 = lightness + saturation - lightness * saturation
        }
        let tmp2: CGFloat = (2.0 * lightness) - tmp1
        hCalc /= 360
        var tmpR: CGFloat = hCalc + (1.0/3.0)
        if tmpR < 0 { tmpR += 1 }
        else if tmpR > 1 { tmpR -= 1 }
        
        var tmpG: CGFloat = hCalc
        if tmpG < 0 { tmpG += 1 }
        else if tmpG > 1 { tmpG -= 1 }
        
        var tmpB: CGFloat = hCalc - (1.0/3.0)
        if tmpB < 0 { tmpB += 1 }
        else if tmpB > 1 { tmpB -= 1 }
        return RGBColor(alignColorChannel(tmpR, tmp1, tmp2), alignColorChannel(tmpG, tmp1, tmp2), alignColorChannel(tmpB, tmp1, tmp2), alpha)
    }

    /// Calculates and returns a monochromatic color of the given intensity for this HSLColor.
    ///
    /// - Parameters:
    ///   - saturationMultiplier: How much to deviate from the original saturation.
    ///   - lightnessMultiplier: How much to deviate from the original lightness.
    /// - Returns: A monochromatic color of the given intensity variance from this HSLColor.
    public func monochromaticColor(saturationMultiplier: CGFloat = 1, lightnessMultiplier: CGFloat = 1) -> HSBColor {
        return HSBColor(hue, (saturation * saturationMultiplier).normalized, (lightness * lightnessMultiplier).normalized, alpha)
    }

    /// Calculates the complimentary color to this HSLColor (+-180 degrees on the color wheel)
    public var complimentaryColor: HSLColor {
        get {
            return HSLColor((hue + 180).circleBounded, saturation, lightness, alpha)
        }
    }

    /// Calculates the two split complimentary colors to this HSLColor (+210 / -150 degrees on the color wheel)
    public var splitComplimentaryColors: (HSLColor, HSLColor) {
        get {
            let splitComplimentHue1 = (hue + 150).circleBounded
            let splitComplimentHue2 = (hue + 210).circleBounded
            return (
                HSLColor(splitComplimentHue1, saturation, lightness, alpha),
                HSLColor(splitComplimentHue2, saturation, lightness, alpha)
            )
        }
    }

    /// Calculates the two analogous colors to this HSLColor (+-30 degrees on the color wheel)
    public var analogousColors: (HSLColor, HSLColor) {
        get {
            let analogousHue1 = (hue + 30).circleBounded
            let analogousHue2 = (hue - 30).circleBounded
            return (
                HSLColor(analogousHue1, saturation, lightness, alpha),
                HSLColor(analogousHue2, saturation, lightness, alpha)
            )
        }
    }

    /// Calculates the two triadic colors to this HSLColor (+-120 degrees on the color wheel)
    public var triadicColors: (HSLColor, HSLColor) {
        get {
            let triadicHue1 = (hue + 120).circleBounded
            let triadicHue2 = (hue - 120).circleBounded
            return (
                HSLColor(triadicHue1, saturation, lightness, alpha),
                HSLColor(triadicHue2, saturation, lightness, alpha)
            )
        }
    }

    /// Calculates the three tetradic colors to this HSLColor (+60, +180, +240 degrees on the color wheel)
    public var tetradicColors: (HSLColor, HSLColor, HSLColor) {
        get {
            let tetradicHue1 = (hue + 60).circleBounded
            let tetradicHue2 = (hue + 180).circleBounded
            let tetradicHue3 = (hue + 240).circleBounded
            return (
                HSLColor(tetradicHue1, saturation, lightness, alpha),
                HSLColor(tetradicHue2, saturation, lightness, alpha),
                HSLColor(tetradicHue3, saturation, lightness, alpha)
            )
        }
    }
    
    // MARK: - Helper methods
    
    fileprivate func alignColorChannel(_ channel: CGFloat, _ tmp1: CGFloat, _ tmp2: CGFloat) -> Int {
        var color: CGFloat = 0
        if (channel * 6) < 1 {
            color = (tmp2 + (tmp1 - tmp2) * 6 * channel)
        } else {
            if (channel * 2) < 1 {
                color = tmp1
            } else {
                if (channel * 3) < 2 {
                    color = (tmp2 + (tmp1 - tmp2) * (0.666 - channel) * 6)
                } else {
                    color = tmp2
                }
            }
        }
        return Int(round(color * 255))
    }
}
