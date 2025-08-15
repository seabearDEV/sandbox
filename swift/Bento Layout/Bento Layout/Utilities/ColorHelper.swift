//
//  ColorHelper.swift
//  Bento Layout
//
//  Utility functions for color operations
//

import SwiftUI

struct ColorHelper {
    static func getColorName(_ color: Color) -> String {
        let rgb = getRGBValues(color)
        
        switch (rgb.r, rgb.g, rgb.b) {
        case (0, 122, 255): return "Blue"
        case (255, 59, 48): return "Red"
        case (52, 199, 89): return "Green"
        case (255, 204, 0): return "Yellow"
        case (175, 82, 222): return "Purple"
        case (255, 149, 0): return "Orange"
        case (255, 45, 85): return "Pink"
        case (50, 215, 230): return "Cyan"
        case (0, 199, 190): return "Mint"
        case (88, 86, 214): return "Indigo"
        case (162, 132, 94): return "Brown"
        case (142, 142, 147): return "Gray"
        case (48, 176, 199): return "Teal"
        case (0, 0, 0): return "Black"
        default: return "Color"
        }
    }
    
    static func getColorHex(_ color: Color) -> String {
        let rgb = getRGBValues(color)
        return String(format: "#%02X%02X%02X", rgb.r, rgb.g, rgb.b)
    }
    
    static func getRGBValues(_ color: Color) -> (r: Int, g: Int, b: Int) {
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}