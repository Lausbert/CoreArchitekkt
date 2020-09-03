// Copyright © 2020 Stephan Lerner. All rights reserved.

import AppKit

public extension NSResponder {

    var currentWindow: NSWindow {
        get {
            switch self {
            case let view as NSView:
                return view.window ?? nextResponder!.currentWindow
            case let viewController as NSViewController:
                return viewController.view.window ?? nextResponder!.currentWindow
            case let window as NSWindow:
                return window
            default:
                assertionFailure("Unexpected object \(self) in responder chain.")
                return nextResponder!.currentWindow
            }
        }
    }

}
