//
//  HSLColor.swift
//  Colorspaces
//
//  Created by Jonathan Bailey on 12/15/18.
//  Copyright © 2018 Jonathan Bailey. All rights reserved.
//

import Foundation

public struct HSLColor {
    public let hue: Int
    public let saturation: Int
    public let luminance: Int
    
    public init(_ h: Int, _ s: Int, _ l: Int) {
        self.hue = h
        self.saturation = s
        self.luminance = l
    }
    
    public var uiColor: UIColor {
        get {
            return UIColor(hue: CGFloat(self.hue), saturation: CGFloat(self.saturation), brightness: CGFloat(self.luminance), alpha: 1.0)
        }
    }
    
    public func toRGB() -> RGBColor {
        var hCalc = Float(self.hue)
        let sCalc = Float(saturation)
        let lCalc = Float(luminance)
        if sCalc == 0.0 {
            return RGBColor(Int(round((lCalc * 255.0))), Int(round((lCalc * 255.0))), Int(round((lCalc * 255.0))))
        }
        var tmp1: Float
        if lCalc < 0.5 {
            tmp1 = lCalc * (1.0 + sCalc)
        }
        else {
            tmp1 = lCalc + sCalc - lCalc * sCalc
        }
        let tmp2: Float = 2.0 * lCalc - tmp1
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
        return RGBColor(testRGB(tmpR, tmp1, tmp2), testRGB(tmpG, tmp1, tmp2), testRGB(tmpB, tmp1, tmp2))
    }
    
    private func testRGB(_ channel: Float, _ tmp1: Float, _ tmp2: Float) -> Int {
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
                    color = (tmp2 + (tmp1 - tmp2) * (0.66 - channel) * 6)
                }
                else {
                    color = tmp2
                }
            }
        }
        return Int(round(color * 255))
    }
}
