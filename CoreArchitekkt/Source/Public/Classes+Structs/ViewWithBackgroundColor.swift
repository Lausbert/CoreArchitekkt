//  Copyright © 2019 Stephan Lerner. All rights reserved.

import Cocoa

public class ViewWithBackgroundColor: NSView {
    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else { return nil }
            return NSColor(cgColor: backgroundColor)
        }

        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer?.cornerRadius ?? 0.0
        }

        set {
            wantsLayer = true
            layer?.cornerRadius = newValue
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
