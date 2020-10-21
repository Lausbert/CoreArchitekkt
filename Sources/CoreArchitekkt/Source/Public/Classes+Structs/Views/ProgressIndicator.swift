// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

public struct ProgressIndicator: NSViewRepresentable {
    
    // MARK: - Public -
    
    
    public init(style: NSProgressIndicator.Style = .bar, isIndeterminate: Bool = false, doubleValue: Double = 0.0) {
        self.style = style
        self.isIndeterminate = isIndeterminate
        self.doubleValue = doubleValue
    }
    
    public func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.maxValue = 1.0
        progressIndicator.minValue = 0.0
        progressIndicator.style = style
        progressIndicator.isIndeterminate = isIndeterminate
        return progressIndicator
    }
    
    public func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        nsView.doubleValue = doubleValue
        nsView.startAnimation(nil)
        nsView.isHidden = !isIndeterminate && (doubleValue == 0.0 || doubleValue == 1.0)
        if doubleValue == 1.0 {
            nsView.doubleValue = 0.0
        }
    }
    
    // MARK: - Private -
    
    private let doubleValue: Double
    private let style: NSProgressIndicator.Style
    private let isIndeterminate: Bool
}
