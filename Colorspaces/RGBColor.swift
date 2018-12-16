//
//  RGBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public struct RGBColor {
    
    /// The red channel of this RGB color (0 - 255).
    public let red: Int
    
    /// The green channel of this RGB color (0 - 255).
    public let green: Int
    
    /// The blue channel of this RGB color (0 - 255).
    public let blue: Int
    
    /// Initializes a new RGBColor object with the given red, green and blue channels (0-255).
    ///
    /// - Parameters:
    ///   - r: The red channel.
    ///   - g: The green channel.
    ///   - b: The blue channel.
    public init(_ r: Int, _ g: Int, _ b: Int) {
        self.red = r
        self.green = g
        self.blue = b
    }
    
    /// The UIColor equivalent of this RGB color.
    public var uiColor: UIColor {
        return UIColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: 1.0)
    }
    
    /// The hexadecimal string representation of this RGB color.
    public var hex: String {
        return "#" + String(red, radix: 16) + String(green, radix: 16) + String(blue, radix: 16)
    }
    
    /// Calculates and returns a monochromatic color of the given intensity for this RGB color.
    ///
    /// - Parameter intensity: How much to deviate in the monochromatic spectrum while calculating.
    /// - Returns: A monochromatic color of the given intensity variance from this RGB color.
    public func getMonochromaticColor(intensity: Float) -> RGBColor {
        var red = Float(self.red) - (100 * intensity)
        if red < 0 { red += 255 }
        
        var green = Float(self.green) + (100 * intensity)
        if green > 255 { green -= 255 }
        
        var blue = Float(self.blue) + (100 * intensity)
        if blue > 255 { blue -= 255 }
        return RGBColor(Int(red), Int(green), Int(blue))
    }
    
    /// Calculates and returns the complimentary color to this RGB color.
    ///
    /// - Returns: The complimentary color to this RGB color.
    public func getComplimentaryColor() -> RGBColor {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let compliment = check360Bounds(rounded.red + 180)
        return HSLColor(compliment, hsl.saturation, hsl.luminance).toRGB()
    }
    
    /// Calculates and returns the two other colors in the split-complimentary color scheme of this RGB color.
    ///
    /// - Returns: The two other split-complimentary colors for this RGB color.
    public func getSplitComplimentaryColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let compliment = check360Bounds(rounded.red + 180)
        let splitCompliment1 = check360Bounds(compliment + 30)
        let splitCompliment2 = check360Bounds(compliment - 30)
        return (HSLColor(splitCompliment1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(splitCompliment2, hsl.saturation, hsl.luminance).toRGB())
    }
    
    /// Calculates and returns the two other colors in the analogous color scheme of this RGB color.
    ///
    /// - Returns: The two other analogous colors for this RGB color.
    public func getAnalogousColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let analogous1 = check360Bounds(rounded.red + 30)
        let analogous2 = check360Bounds(rounded.red - 30)
        return (HSLColor(analogous1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(analogous2, hsl.saturation, hsl.luminance).toRGB())
    }
    
    /// Calculates and returns the two other colors in the triadic color scheme of this RGB color.
    ///
    /// - Returns: The two other triadic colors for this RGB color.
    public func getTriadicColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let triadic1 = check360Bounds(rounded.red + 120)
        let triadic2 = check360Bounds(rounded.red - 120)
        return (HSLColor(triadic1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(triadic2, hsl.saturation, hsl.luminance).toRGB())
    }
    
    /// Calculates and returns the three other colors in the tetradic color scheme of this RGB color.
    ///
    /// - Returns: The three other tetradic colors for this RGB color.
    public func getTetradicColors() -> (RGBColor, RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        var tetra1 = rounded.red + 60
        if tetra1 > 360 { tetra1 -= 360 }
        
        var tetra2 = rounded.red + 180
        if tetra2 > 360 { tetra2 -= 360 }
        
        var tetra3 = tetra1 + 180
        if tetra3 > 360 { tetra3 -= 360 }
        
        let t1 = HSLColor(tetra1, hsl.saturation, hsl.luminance).toRGB()
        let t2 = HSLColor(tetra2, hsl.saturation, hsl.luminance).toRGB()
        let t3 = HSLColor(tetra3, hsl.saturation, hsl.luminance).toRGB()
        
        return (t1, t2, t3)
    }
    
    /// Calculates and returns the HSL (Hue, Saturation, Luminosity) equivalent of this RGB color.
    ///
    /// - Returns: The HSL equivalent of this RGB color.
    public func toHSL() -> HSLColor {
        let norms = [(Float(self.red)/255), (Float(self.green)/255), (Float(self.blue)/255)]
        let red = norms[0]
        let green = norms[1]
        let blue = norms[2]
        let max = norms.max()!
        let min = norms.min()!
        let luminance = (max + min)/2
        var saturation: Float = 0
        var hue: Float = 0
        if !min.isEqual(to: max) {
            if luminance < 0.5 {
                saturation = (max - min)/(max + min)
            }
            else {
                saturation = (max - min)/(2.0 - max - min)
            }
        }
        if max.isEqual(to: red) {
            hue = (green - blue)/(max - min)
        }
        else if max.isEqual(to: green) {
            hue = 2.0 + ((blue - red)/(max - min))
        }
        else {
            hue = 4.0 + ((red - green)/(max - min))
        }
        hue *= 60
        if hue < 0 { hue += 360 }
        return HSLColor(Int(round(hue)), saturation, luminance)
    }
    
    /// Calculates and returns the HSB (Hue, Saturation, Brightness) equivalent of this RGB color.
    ///
    /// - Returns: The HSB equivalent of this RGB color.
    public func toHSB() -> HSBColor {
        let _r = Float(red)/255
        let _g = Float(green)/255
        let _b = Float(blue)/255
        let max = Swift.max(_r, _g, _b)
        let min = Swift.min(_r, _g, _b)
        let delta = max - min
        var hue: Float = 0
        var saturation: Float = 0
        let brightness: Float = max
        if !delta.isEqual(to: 0) && !max.isEqual(to: 0) {
            if max.isEqual(to: _r) {
                hue = 60 * (((_g - _b) / delta).mod(by: 6))
                saturation = delta/max
            }
            else if max.isEqual(to: _g) {
                hue = 60 * (((_b - _r) / delta) + 2)
                saturation = delta/max
            }
            else {
                hue = 60 * (((_r - _g) / delta) + 4)
                saturation = delta/max
            }
        }
        return HSBColor(Int(round(hue)), saturation, brightness)
    }
    
    // MARK: - Helper methods
    
    private func roundValues(color: HSLColor, rgb: Bool) -> RGBColor {
        return RGBColor(color.hue, Int(round(color.saturation * 100)), Int(round(color.luminance * 100)))
    }
    
    private func check360Bounds(_ num: Int) -> Int {
        if num > 360 { return num - 360 }
        else if num < 0 { return num + 360 }
        else { return num }
    }
}
