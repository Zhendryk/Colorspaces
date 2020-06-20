//
//  ColorspacesTests.swift
//  ColorspacesTests
//
//  Created by Jonathan Bailey on 6/19/20.
//  Copyright © 2020 Jonathan Bailey. All rights reserved.
//

import XCTest
import Colorspaces

extension CGFloat {

    func roundedToPlaces(places: Int) -> CGFloat {
        if let n = Double(String(format: "%.\(places)f", self)) {
            return CGFloat(n)
        }
        else {
            return CGFloat.nan
        }
    }

}

extension Int {

    func isWithin(range: Int, of num: Int) -> Bool {
        return ((num - range) <= self && self <= (num + range)) ? true : false
    }

}

extension String {

    func isWithin(range: Int, ofHex hex: String) -> Bool {
        guard let hexNumOther = Int(hex.replacingOccurrences(of: "#", with: ""), radix: 16) else { return false }
        guard let hexNumSelf = Int(self.replacingOccurrences(of: "#", with: ""), radix: 16) else { return false }
        return (hexNumOther - range) <= hexNumSelf && hexNumSelf <= (hexNumOther + range)
    }
}

class ColorspacesTests: XCTestCase {

    let rgb = RGBColor(24, 120, 65)
    let hsl = HSLColor(146, 0.667, 0.282)
    let hsb = HSBColor(146, 0.80, 0.471)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test__rgb_to_hsl_conversion() {
        let hsl = rgb.hsl
        XCTAssert(hsl.hue == 146)
        XCTAssert(hsl.saturation.roundedToPlaces(places: 3) == 0.667)
        XCTAssert(hsl.lightness.roundedToPlaces(places: 3) == 0.282)
    }

    func test__hsl_to_rgb_conversion() {
        let rgb = hsl.rgb
        // Account for possible *slight* precision loss when converting back to RGB
        XCTAssert(rgb.red.isWithin(range: 1, of: 24))
        XCTAssert(rgb.green.isWithin(range: 1, of: 120))
        XCTAssert(rgb.blue.isWithin(range: 1, of: 65))
    }

    func test__rgb_to_hsb_conversion() {
        let hsb = rgb.hsb
        XCTAssert(hsb.hue == 146)
        XCTAssert(hsb.saturation.roundedToPlaces(places: 3) == 0.80)
        XCTAssert(hsb.brightness.roundedToPlaces(places: 3) == 0.471)
    }

    func test__hsb_to_rgb_conversion() {
        let rgb = hsb.rgb
        // Account for possible *slight* precision loss when converting back to RGB
        XCTAssert(rgb.red.isWithin(range: 1, of: 24))
        XCTAssert(rgb.green.isWithin(range: 1, of: 120))
        XCTAssert(rgb.blue.isWithin(range: 1, of: 65))
    }

    func test__rgb_to_hex_conversion() {
        // Slight difference from HSL/HSB
        XCTAssert(rgb.hex.isWithin(range: 1, ofHex: "#187842"))
    }

    func test__hsl_to_hex_conversion() {
        XCTAssert(hsl.hex == "#187842")
    }

    func test__hsb_to_hex_conversion() {
        XCTAssert(hsb.hex == "#187841")
    }

    func test_rgb_complimentary_color() {
        XCTAssert(rgb.complimentaryColor.hex == "#78184E")
    }

    func test_rgb_split_complimentary_colors() {
        let (sc1, sc2) = rgb.splitComplimentaryColors
        XCTAssert(sc1.hex == "#721878")
        XCTAssert(sc2.hex == "#78181E")
    }

    func test_rgb_analogous_colors() {
        let (a1, a2) = rgb.analogousColors
        XCTAssert(a1.hex.isWithin(range: 1, ofHex: "#187872"))
        XCTAssert(a2.hex == "#1E7818")
    }

    func test_rgb_triadic_colors() {
        let (tr1, tr2) = rgb.triadicColors
        XCTAssert(tr1.hex == "#421878")
        XCTAssert(tr2.hex == "#784218")
    }

    func test_rgb_tetradic_colors() {
        let (te1, te2, te3) = rgb.tetradicColors
        // Slightly differing values than HSL because of loss of precision from conversion
        XCTAssert(te1.hex == "#181E78")
        XCTAssert(te2.hex == "#78184E")
        XCTAssert(te3.hex == "#787218")
    }

    func test_hsl_complimentary_color() {
        XCTAssert(hsl.complimentaryColor.hex == "#78184E")
    }

    func test_hsl_split_complimentary_colors() {
        let (sc1, sc2) = hsl.splitComplimentaryColors
        XCTAssert(sc1.hex == "#711878")
        XCTAssert(sc2.hex == "#78181E")
    }

    func test_hsl_analogous_colors() {
        let (a1, a2) = hsl.analogousColors
        XCTAssert(a1.hex == "#187871")
        XCTAssert(a2.hex == "#1E7818")
    }

    func test_hsl_triadic_colors() {
        let (tr1, tr2) = hsl.triadicColors
        XCTAssert(tr1.hex == "#421878")
        XCTAssert(tr2.hex == "#784218")
    }

    func test_hsl_tetradic_colors() {
        let (te1, te2, te3) = hsl.tetradicColors
        XCTAssert(te1.hex == "#181E78")
        XCTAssert(te2.hex == "#78184E")
        XCTAssert(te3.hex == "#787118")
    }

    func test_hsb_complimentary_color() {
        XCTAssert(hsb.complimentaryColor.hex == "#78184E")
    }

    func test_hsb_split_complimentary_colors() {
        let (sc1, sc2) = hsb.splitComplimentaryColors
        XCTAssert(sc1.hex == "#711878")
        XCTAssert(sc2.hex == "#78181E")
    }

    func test_hsb_analogous_colors() {
        let (a1, a2) = hsb.analogousColors
        XCTAssert(a1.hex == "#187871")
        XCTAssert(a2.hex == "#1E7818")
    }

    func test_hsb_triadic_colors() {
        let (tr1, tr2) = hsb.triadicColors
        XCTAssert(tr1.hex == "#411878")
        XCTAssert(tr2.hex == "#784118")
    }

    func test_hsb_tetradic_colors() {
        let (te1, te2, te3) = hsb.tetradicColors
        XCTAssert(te1.hex == "#181E78")
        XCTAssert(te2.hex == "#78184E")
        XCTAssert(te3.hex == "#787118")
    }
}
