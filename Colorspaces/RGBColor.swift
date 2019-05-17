//
//  RGBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public struct RGBColor {
    
    /// The red channel of this RGBColor (0 - 255).
    public let red: Int
    
    /// The green channel of this RGBColor (0 - 255).
    public let green: Int
    
    /// The blue channel of this RGBColor (0 - 255).
    public let blue: Int

    /// The alpha channel of this RGBColor (0.0 - 1.0)
    public let alpha: CGFloat
    
    /// Initializes a new RGBColor object with the given red, green and blue channels (0-255).
    ///
    /// - Parameters:
    ///   - r: The red channel (0 - 255).
    ///   - g: The green channel (0 - 255).
    ///   - b: The blue channel (0 - 255).
    ///   - a: The alpha (0.0 - 1.0).
    public init(_ r: Int, _ g: Int, _ b: Int, _ a: CGFloat = 1) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }
    
    /// Calculates and returns the HSL (Hue, Saturation, Lightness) equivalent of this RGB color.
    ///
    /// - Returns: The HSL equivalent of this RGB color.
    public var hsl: HSLColor {
        let r = CGFloat(red)/255, g = CGFloat(
            green)/255, b = CGFloat(blue)/255
        let max: CGFloat = Swift.max(r, g, b)
        let min: CGFloat = Swift.min(r, g, b)
        var hue: CGFloat = 0, saturation: CGFloat = 0, lightness: CGFloat = (max + min) / 2
        if min != max {
            if lightness < 0.5 {
                saturation = (max - min) &/ (max + min)
            } else {
                saturation = (max - min) &/ (2 - max - min)
            }
        }
        if max == r {
            hue = (g - b) &/ (max - min)
        } else if max == g {
            hue = ((b - r) &/ (max - min)) + 2
        } else {
            hue = ((r - g) &/ (max - min)) + 4
        }
        hue *= 60
        if hue < 0 { hue += 360 }
        return HSLColor(Int(hue.rounded()), saturation, lightness)
    }
    
    /// Calculates and returns the HSB (Hue, Saturation, Brightness) equivalent of this RGB color.
    ///
    /// - Returns: The HSB equivalent of this RGB color.
    public var hsb: HSBColor {
        let r = CGFloat(red)/255, g = CGFloat(
            green)/255, b = CGFloat(blue)/255
        let max = Swift.max(r, g, b)
        let min = Swift.min(r, g, b)
        let delta = max - min
        var hue: CGFloat, saturation: CGFloat, brightness: CGFloat = max
        // Hue calculation
        if delta.isZero {
            hue = 0
        }
        if max == r {
            hue = 60 * (((g - b) &/ delta) % 6)
        } else if max == g {
            hue = 60 * (((b - r) &/ delta) + 2)
        } else {
            hue = 60 * (((r - g) &/ delta) + 4)
        }
        // Saturation calculation
        if max.isZero {
            saturation = 0
        } else {
            saturation = delta &/ max
        }
        return HSBColor(Int(hue.rounded()), saturation, brightness)
    }
    
    /// The UIColor equivalent of this RGB color.
    public var uiColor: UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
    
    /// The hexadecimal string representation of this RGB color.
    public var hex: String {
        return "#" + String(red, radix: 16) + String(green, radix: 16) + String(blue, radix: 16)
    }

    /// Returns a formatted string of this color in the format: "(r: `self.red`, g: `self.green`, b: `self.blue`, a: `self.alpha`)"
    public var string: String {
        get {
            return "(r: \(red), g: \(green), b: \(blue), a: \(alpha))"
        }
    }

    /// Returns the euclidean distance between this and another RGBColor.
    ///
    /// - Parameter color: The color you are measuring distance to.
    /// - Returns: The euclidean distance from this color to the given color.
    public func distance(from color: RGBColor) -> Double {
        let x = pow(Double(red - color.red), 2)
        let y = pow(Double(green - color.green), 2)
        let z = pow(Double(blue - color.blue), 2)
        return sqrt(x + y + z)
    }
}
