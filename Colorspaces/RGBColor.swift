//
//  RGBColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public struct RGBColor {
    public let red: Int
    public let green: Int
    public let blue: Int
    
    public init(_ r: Int, _ g: Int, _ b: Int) {
        self.red = r
        self.green = g
        self.blue = b
    }
    
    public var uiColor: UIColor {
        get {
            return UIColor(red: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: 1.0)
        }
    }
    
    public func getMonochromaticColor(intensity: Float) -> RGBColor {
        var red = Float(self.red) - (100 * intensity)
        if red < 0 { red += 255 }
        
        var green = Float(self.green) + (100 * intensity)
        if green > 255 { green -= 255 }
        
        var blue = Float(self.blue) + (100 * intensity)
        if blue > 255 { blue -= 255 }
        return RGBColor(Int(red), Int(green), Int(blue))
    }
    
    public func getComplimentaryColor() -> RGBColor {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let compliment = check360Bounds(rounded.red + 180)
        return HSLColor(compliment, hsl.saturation, hsl.luminance).toRGB()
    }
    
    public func getSplitComplimentaryColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let compliment = check360Bounds(rounded.red + 180)
        let splitCompliment1 = check360Bounds(compliment + 30)
        let splitCompliment2 = check360Bounds(compliment - 30)
        return (HSLColor(splitCompliment1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(splitCompliment2, hsl.saturation, hsl.luminance).toRGB())
    }
    
    public func getAnalogousColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let analogous1 = check360Bounds(rounded.red + 30)
        let analogous2 = check360Bounds(rounded.red - 30)
        return (HSLColor(analogous1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(analogous2, hsl.saturation, hsl.luminance).toRGB())
    }
    
    public func getTriadicColors() -> (RGBColor, RGBColor) {
        let hsl = toHSL()
        let rounded = roundValues(color: hsl, rgb: false)
        let triadic1 = check360Bounds(rounded.red + 120)
        let triadic2 = check360Bounds(rounded.red - 120)
        return (HSLColor(triadic1, hsl.saturation, hsl.luminance).toRGB(), HSLColor(triadic2, hsl.saturation, hsl.luminance).toRGB())
    }
    
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
    
    public func toHSL() -> HSLColor {
        let norms = [Float(self.red/255), Float(self.green/255), Float(self.blue/255)]
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
        return HSLColor(Int(hue), Int(saturation), Int(luminance))
    }
    
    public func toCMYK() -> CMYKColor {
        let r = Float(red)/255.0
        let g = Float(green)/255.0
        let b = Float(blue)/255.0
        let k = 1.0 - max(r, g, b)
        let c = (1.0 - r - k)/(1.0 - k)
        let m = (1.0 - g - k)/(1.0 - k)
        let y = (1.0 - b - k)/(1.0 - k)
        return CMYKColor(Int(c), Int(m), Int(y), Int(k))
    }
    
    public func toHSB() -> HSBColor {
        var hue: Float = 0
        var saturation: Float = 0
        var brightness: Float = 0
        let maxValue = max(red, green, blue)
        let minValue = min(red, green, blue)
        brightness = Float(maxValue)/255.0
        if maxValue != 0 {
            saturation = Float(maxValue - minValue)/Float(maxValue)
        }
        else { saturation = 0 }
        if saturation == 0 { hue = 0 }
        else {
            let _r: Float = Float(maxValue - red)/Float(maxValue - minValue)
            let _g: Float = Float(maxValue - green)/Float(maxValue - minValue)
            let _b: Float = Float(maxValue - blue)/Float(maxValue - minValue)
            if maxValue == minValue {
                hue = 0
            }
            else if maxValue == red {
                hue = 60 * (_b - _g)
            }
            else if maxValue == green {
                hue = 60 * (2.0 + _r - _b)
            }
            else {
                hue = 60 * (4.0 + _g - _r)
            }
            if hue < 0 { hue += 360 }
        }
        return HSBColor(Int(hue), Int(saturation), Int(brightness))
    }
    
    public func toHex(_ prependHash: Bool = false) -> String {
        if prependHash {
            return "#" + String(red, radix: 16) + String(green, radix: 16) + String(blue, radix: 16)
        }
        else {
            return String(red, radix: 16) + String(green, radix: 16) + String(blue, radix: 16)
        }
    }
    
    private func roundValues(color: HSLColor, rgb: Bool) -> RGBColor {
        var channel1: Int
        var channel2: Int
        var channel3: Int
        if rgb {
            channel1 = color.hue
            channel2 = color.saturation
            channel3 = color.luminance
        }
        else {
            channel1 = color.hue
            channel2 = ((color.saturation*100)/100) * 100
            channel3 = ((color.luminance*100)/100) * 100
        }
        return RGBColor(channel1, channel2, channel3)
    }
    
    private func check360Bounds(_ num: Int) -> Int {
        if num > 360 { return num - 360 }
        else if num < 0 { return num + 360 }
        else { return num }
    }
}
