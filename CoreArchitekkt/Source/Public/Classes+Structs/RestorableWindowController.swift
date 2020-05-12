// Copyright © 2020 Stephan Lerner. All rights reserved.

import Cocoa

open class RestorableWindowController: NSWindowController {

    // MARK: - Public -

    open override func windowDidLoad() {
        super.windowDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: NSWindow.willCloseNotification, object: nil)
        if let frame = storedFrame {
            window?.setFrame(frame, display: true)
        }
    }

    open override func awakeFromNib() {
        super.awakeFromNib()

        if let frame = storedFrame {
            window?.setFrame(frame, display: true)
        }
    }

    // MARK: - Private -

    private var storedFrameKey: String {
        String(describing: type(of: self)) + "/storedFrameKey"
    }
    private var storedFrame: NSRect? {
        guard let string = UserDefaults.standard.string(forKey: storedFrameKey) else {
            return nil
        }
        return NSRectFromString(string)
    }

    @objc private func windowWillClose() {
        guard let frame = window?.frame else {
            return
        }
        UserDefaults.standard.set(NSStringFromRect(frame), forKey: storedFrameKey)
    }

}
