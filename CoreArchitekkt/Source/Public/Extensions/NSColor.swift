//
//  NSColor.swift
//  SKArchitekkt
//
//  Created by Stephan Lerner on 08.02.20.
//

import Foundation

extension NSColor {

    static func color(named name: String) -> NSColor {
        return NSColor(named: name, bundle: Bundle(identifier: "org.cocoapods.CoreArchitekkt")) ?? #colorLiteral(red: 0.3293760121, green: 0.329436779, blue: 0.3293679655, alpha: 1)
    }

}
