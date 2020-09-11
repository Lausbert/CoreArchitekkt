// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

public struct DarkVerticalDivider: View {
    
    // MARK: - Public -
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width)
            .edgesIgnoringSafeArea(.vertical)
    }
    
    public init() {}
    
    // MARK: - Internal -
    
    let color: Color = .separatorColor
    let width: CGFloat = 1
}
