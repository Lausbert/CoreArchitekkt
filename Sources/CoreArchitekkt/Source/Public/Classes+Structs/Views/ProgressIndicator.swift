// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

public struct ProgressIndicator: NSViewRepresentable {
    
    // MARK: - Public -
    
    @Binding public var doubleValue: Double
    
    public init(style: NSProgressIndicator.Style = .bar, isIndeterminate: Bool = false, doubleValue: Binding<Double>? = nil) {
        self.style = style
        self.isIndeterminate = isIndeterminate
        if let binding = doubleValue {
            self._doubleValue = binding
        } else {
            self._doubleValue = Binding<Double>(get: { 0.0 }, set: { _ in })
        }
    }
    
    public func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.style = style
        progressIndicator.isIndeterminate = isIndeterminate
        progressIndicator.doubleValue = doubleValue
        progressIndicator.startAnimation(nil)
        return progressIndicator
    }
    
    public func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressIndicator>) {
        nsView.doubleValue = doubleValue
    }
    
    // MARK: - Private -
    
    private let style: NSProgressIndicator.Style
    private let isIndeterminate: Bool
}
