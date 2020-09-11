// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

struct Stretch: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

struct StretchTopLeading: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
}

public extension View {
    
    func stretch() -> some View {
        self.modifier(Stretch())
    }
    
    func stretchTopLeading() -> some View {
        self.modifier(StretchTopLeading())
    }
    
}
