// Copyright © 2020 Stephan Lerner. All rights reserved.

import CoreGraphics

public struct CodableColor: Hashable, Codable {
    
    public let red: Float
    public let green: Float
    public let blue: Float
    public let alpha: Float
    
    public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
        func clamp(_ value: Float) -> Float {
            return min(1, max(0, value))
        }
        
        self.red = clamp(red)
        self.green = clamp(green)
        self.blue = clamp(blue)
        self.alpha = clamp(alpha)
    }
    
    public func with(alpha: Float) -> CodableColor {
        return CodableColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension CodableColor {
    
    public init(literalRed red: Int, green: Int, blue: Int, alpha: Float = 1) {
        self.init(red: Float(red)/255, green: Float(green)/255, blue: Float(blue)/255, alpha: alpha)
    }
    
}

extension CodableColor {
    
    public init?(hex: Int, alpha: Float? = nil) {
        self.init(hex: String(format:"%2X", hex), alpha: alpha)
    }
    
    public init?(hex: String, alpha: Float? = nil) {
        var hexValue = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        guard [3, 4, 6, 8].contains(hexValue.count) else { return nil }
        
        if hexValue.count == 3 {
            hexValue.append("F")
        }
        
        if hexValue.count == 6 {
            hexValue.append("FF")
        }
        
        if [3, 4].contains(hexValue.count) {
            for (index, char) in hexValue.enumerated() {
                let index = hexValue.index(hexValue.startIndex, offsetBy: index * 2)
                hexValue.insert(char, at: index)
            }
        }
        
        guard let normalizedHex = Int(hexValue, radix: 16) else { return nil }
        
        self.init(
            red:   Float((normalizedHex >> 24) & 0xFF) / 255,
            green: Float((normalizedHex >> 16) & 0xFF) / 255,
            blue:  Float((normalizedHex >> 8)  & 0xFF) / 255,
            alpha: alpha ?? Float((normalizedHex)  & 0xFF) / 255)
    }
    
    public func toHex(withAlpha: Bool = true) -> String {
        let alpha = withAlpha ? String(format: "%02X", Int(self.alpha * 255)) : ""
        return String(format: "%02X%02X%02X\(alpha)", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
    
}

extension CodableColor {
    
    public init(white: Float, alpha: Float = 1) {
        self.init(red: white, green: white, blue: white, alpha: alpha)
    }
    
    public init?(cgColor: CGColor) {
        guard let components = cgColor.components else { return nil }
        let red, green, blue, alpha: Float
        
        if components.count == 2 {
            red = Float(components[0])
            green = Float(components[0])
            blue = Float(components[0])
            alpha = Float(components[1])
        } else {
            red = Float(components[0])
            green = Float(components[1])
            blue = Float(components[2])
            alpha = Float(components[3])
        }
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var cgColor: CGColor {
        return CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(),
                       components: [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])!
    }
    
}

extension CodableColor {
    
    public var isDark: Bool {
        return (0.2126 * red + 0.7152 * green + 0.0722 * blue) < 0.5
    }
    
    public func inverted() -> CodableColor {
        return CodableColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }
    
}

extension CodableColor {
    
    public static var black: CodableColor { return CodableColor(white: 0) }
    public static var darkGray: CodableColor { return CodableColor(white: 0.333) }
    public static var lightGray: CodableColor { return CodableColor(white: 0.667) }
    public static var white: CodableColor { return CodableColor(white: 1) }
    public static var gray: CodableColor { return CodableColor(white: 0.5) }
    public static var red: CodableColor { return CodableColor(red: 1, green: 0, blue: 0) }
    public static var green: CodableColor { return CodableColor(red: 0, green: 1, blue: 0) }
    public static var blue: CodableColor { return CodableColor(red: 0, green: 0, blue: 1) }
    public static var cyan: CodableColor { return CodableColor(red: 0, green: 1, blue: 1) }
    public static var yellow: CodableColor { return CodableColor(red: 1, green: 1, blue: 0) }
    public static var magenta: CodableColor { return CodableColor(red: 1, green: 0, blue: 1) }
    public static var orange: CodableColor { return CodableColor(red: 1, green: 0.5, blue: 0) }
    public static var purple: CodableColor { return CodableColor(red: 0.5, green: 0, blue: 0.5) }
    public static var brown: CodableColor { return CodableColor(red: 0.6, green: 0.4, blue: 0.2) }
    public static var clear: CodableColor { return CodableColor(white: 0, alpha: 0) }
    
}

extension CodableColor: ExpressibleByStringLiteral {
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(hex: value)!
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(hex: value)!
    }
    
    public init(stringLiteral value: String) {
        self.init(hex: value)!
    }
    
}

import AppKit
extension CodableColor {
    public init?(systemColor: NSColor?) {
        guard let systemColor = systemColor else { return nil }
        self.init(cgColor: systemColor.cgColor)
    }
    
    public var systemColor: NSColor {
        return NSColor(cgColor: cgColor)!
    }
}

