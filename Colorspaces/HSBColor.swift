//
//  HSBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public struct HSBColor {
    
    /// The hue of this HSBColor (0 - 360).
    public let hue: Int
    
    /// The saturation of this HSBColor (0 - 100% == 0.0 - 1.0).
    public let saturation: CGFloat
    
    /// The brightness of this HSBColor (0 - 100% == 0.0 - 1.0).
    public let brightness: CGFloat

    /// The alpha of this HSBColor (0.0 - 1.0)
    public let alpha: CGFloat
    
    /// Initializes a new HSBColor object with the given hue, saturation and brightness.
    ///
    /// - Parameters:
    ///   - h: The hue (0 - 360).
    ///   - s: The saturation (0.0 - 1.0).
    ///   - b: The brightness (0.0 - 1.0).
    ///   - a: The alpha (0.0 - 1.0).
    public init(_ h: Int, _ s: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) {
        self.hue = h
        self.saturation = s
        self.brightness = b
        self.alpha = a
    }
    
    /// The UIColor equivalent of this HSBColor.
    public var uiColor: UIColor {
        return UIColor(hue: CGFloat(hue), saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    /// The hexadecimal string representation of this HSBColor.
    public var hex: String {
        return rgb.hex
    }

    /// Returns a formatted string of this color in the format: "(h: `self.hue`, s: `self.saturation`, b: `self.brightness`, a: `self.alpha`)"
    public var string: String {
        get {
            return "(h: \(hue), s: \(saturation), b: \(brightness), a: \(alpha))"
        }
    }

    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this HSBColor.
    ///
    /// - Returns: The RGB equivalent of this HSBColor.
    public var rgb: RGBColor {
        let chroma = brightness * saturation
        let x = chroma * (1 - (abs((CGFloat(hue) / 60) % 2) - 1))
        let m = brightness - chroma
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        if (hue >= 0 || hue == 360) && hue < 60 {
            r = chroma
            g = x
        } else if hue >= 60 && hue < 120 {
            r = x
            g = chroma
        } else if hue >= 120 && hue < 180 {
            g = chroma
            b = x
        } else if hue >= 180 && hue < 240 {
            g = x
            b = chroma
        } else if hue >= 240 && hue < 300 {
            r = x
            b = chroma
        } else if hue >= 300 && hue < 360 {
            r = chroma
            b = x
        }
        return RGBColor(Int((r + m)*255), Int((g + m)*255), Int((b + m)*255), alpha)
    }

    /// Calculates and returns a monochromatic color of the given intensity for this HSBColor.
    ///
    /// - Parameters:
    ///   - saturationMultiplier: How much to deviate from the original saturation.
    ///   - lightnessMultiplier: How much to deviate from the original brightness.
    /// - Returns: A monochromatic color of the given intensity variance from this HSBColor.
    public func monochromaticColor(saturationMultiplier: CGFloat = 1, brightnessMultiplier: CGFloat = 1) -> HSBColor {
        return HSBColor(hue, (saturation * saturationMultiplier).normalized, (brightness * brightnessMultiplier).normalized, alpha)
    }

    /// Calculates the complimentary color to this HSBColor (+-180 degrees on the color wheel)
    public var complimentaryColor: HSBColor {
        get {
            return HSBColor((hue + 180).circleBounded, saturation, brightness, alpha)
        }
    }

    /// Calculates the two split complimentary colors to this HSBColor (+210 / -150 degrees on the color wheel)
    public var splitComplimentaryColors: (HSBColor, HSBColor) {
        get {
            let splitComplimentHue1 = (hue + 150).circleBounded
            let splitComplimentHue2 = (hue + 210).circleBounded
            return (
                HSBColor(splitComplimentHue1, saturation, brightness, alpha),
                HSBColor(splitComplimentHue2, saturation, brightness, alpha)
            )
        }
    }

    /// Calculates the two analogous colors to this HSBColor (+-30 degrees on the color wheel)
    public var analogousColors: (HSBColor, HSBColor) {
        get {
            let analogousHue1 = (hue + 30).circleBounded
            let analogousHue2 = (hue - 30).circleBounded
            return (
                HSBColor(analogousHue1, saturation, brightness, alpha),
                HSBColor(analogousHue2, saturation, brightness, alpha)
            )
        }
    }

    /// Calculates the two triadic colors to this HSBColor (+-120 degrees on the color wheel)
    public var triadicColors: (HSBColor, HSBColor) {
        get {
            let triadicHue1 = (hue + 120).circleBounded
            let triadicHue2 = (hue - 120).circleBounded
            return (
                HSBColor(triadicHue1, saturation, brightness, alpha),
                HSBColor(triadicHue2, saturation, brightness, alpha)
            )
        }
    }

    /// Calculates the three tetradic colors to this HSBColor (+60, +180, +240 degrees on the color wheel)
    public var tetradicColors: (HSBColor, HSBColor, HSBColor) {
        get {
            let tetradicHue1 = (hue + 60).circleBounded
            let tetradicHue2 = (hue + 180).circleBounded
            let tetradicHue3 = (hue + 240).circleBounded
            return (
                HSBColor(tetradicHue1, saturation, brightness, alpha),
                HSBColor(tetradicHue2, saturation, brightness, alpha),
                HSBColor(tetradicHue3, saturation, brightness, alpha)
            )
        }
    }
}
