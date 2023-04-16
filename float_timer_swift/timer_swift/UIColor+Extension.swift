//
// Created by SQ on 2018/2/13.
// Copyright (c) 2018 zjupapic. All rights reserved.
//

import UIKit

extension UIColor {
    public static func colorWithHexString(_ hex: String) -> UIColor {
        colorWithHexString(hex, alpha: 1)
    }
    
    public static func colorWithHexString(_ hex: String, alpha: CGFloat) -> UIColor {
        var color = UIColor.black
        var cStr: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if cStr.hasPrefix("#") {
            let index = cStr.index(after: cStr.startIndex)
            cStr = String(cStr[index...])
        }
        if cStr.count != 6 {
            return UIColor.black
        }

        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = String(cStr[rRange])

        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = String(cStr[gRange])

        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = String(cStr[bIndex...])

        var r: CUnsignedInt = 0, g: CUnsignedInt = 0, b: CUnsignedInt = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)

        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))

        return color
    }
}
