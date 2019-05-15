//
//  HSLColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

public struct HSLColor {
    
    /// The hue of this HSL color (0-360).
    public let hue: Int
    
    /// The saturation of this HSL color (0 - 100% == 0.0 - 1.0).
    public let saturation: Float
    
    /// The luminance of this HSL color (0 - 100% == 0.0 - 1.0).
    public let luminance: Float
    
    /// Initializes a new HSLColor object with the given hue, saturation and luminance.
    ///
    /// - Parameters:
    ///   - h: The hue (0 - 360).
    ///   - s: The saturation (0.0 - 1.0).
    ///   - l: The luminance (0.0 - 1.0).
    public init(_ h: Int, _ s: Float, _ l: Float) {
        self.hue = h
        self.saturation = s
        self.luminance = l
    }
    
    /// The UIColor equivalent of this HSL color.
    public var uiColor: UIColor {
        return UIColor(hue: CGFloat(self.hue)/360.0, saturation: CGFloat(self.saturation), brightness: CGFloat(self.luminance), alpha: 1.0)
    }
    
    /// The hexadecimal string representation of this HSL color.
    public var hex: String {
        return rgb.hex
    }
    
    /// Calculates and returns the RGB (Red, Green, Blue) equivalent of this HSL color.
    ///
    /// - Returns: The RGB equivalent of this HSL color.
    public var rgb: RGBColor {
        var hCalc = Float(self.hue)
        if saturation == 0.0 {
            let grayValue = Int(luminance * 255)
            return RGBColor(grayValue, grayValue, grayValue)
        }
        var tmp1: Float
        if luminance < 0.5 {
            tmp1 = luminance * (1 + saturation)
        }
        else {
            tmp1 = luminance + saturation - luminance * saturation
        }
        let tmp2: Float = (2.0 * luminance) - tmp1
        hCalc /= 360
        var tmpR: Float = hCalc + 0.333
        if tmpR < 0 { tmpR += 1 }
        else if tmpR > 1 { tmpR -= 1 }
        
        var tmpG: Float = hCalc
        if tmpG < 0 { tmpG += 1 }
        else if tmpG > 1 { tmpG -= 1 }
        
        var tmpB: Float = hCalc - 0.333
        if tmpB < 0 { tmpB += 1 }
        else if tmpB > 1 { tmpB -= 1 }
        return RGBColor(alignColorChannel(tmpR, tmp1, tmp2), alignColorChannel(tmpG, tmp1, tmp2), alignColorChannel(tmpB, tmp1, tmp2))
    }
    
    // MARK: - Helper methods
    
    fileprivate func alignColorChannel(_ channel: Float, _ tmp1: Float, _ tmp2: Float) -> Int {
        var color: Float = 0
        if (channel * 6) < 1 {
            color = (tmp2 + (tmp1 - tmp2) * 6 * channel)
        }
        else {
            if (channel * 2) < 1 {
                color = tmp1
            }
            else {
                if (channel * 3) < 2 {
                    color = (tmp2 + (tmp1 - tmp2) * (0.666 - channel) * 6)
                }
                else {
                    color = tmp2
                }
            }
        }
        return Int(round(color * 255))
    }
}
