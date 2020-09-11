// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

public typealias SystemImageName = String

public struct SystemTabView: View {
    
    // MARK: - Public -
    
    public enum Side {
        case left
        case right
    }
    
    public init(side: Side, tabs: [(SystemImageName, AnyView)]) {
        self.side = side
        self.tabs = tabs
    }
        
    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if case .right = side {
                    DarkVerticalDivider()
                }
                VStack(spacing: 0) {
                    SystemSegmentControl(selection: $selection, systemImages: tabs.map { $0.0 })
                    Divider()
                    tabs
                        .map { $0.1 }[selection]
                        .stretchTopLeading()
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                if case .left = side {
                    DarkVerticalDivider()
                }
            }
        }
        .frame(width: 250)
    }
    
    // MARK: - Internal -
    
    let side: Side
    let tabs: [(SystemImageName, AnyView)]
    
    // MARK: - Private -
    
    private struct SystemSegmentControl : View {
        
        // MARK: - Internal -

        @Binding var selection : Int
        let systemImages: [SystemImageName]

        var body : some View {
            HStack(spacing: 5) {
                ForEach (0..<systemImages.count) { i in
                    SystemSegmentButton(selection: self.$selection, selectionIndex: i, systemImage: systemImages[i])
                  }
            }
        }
    }


    private struct SystemSegmentButton : View {
        
        // MARK: - Internal -

        @Binding var selection : Int
        let selectionIndex: Int
        let systemImage : SystemImageName

        var body : some View {
            Button(action: { self.selection = self.selectionIndex }) {
                Image(systemName: systemImage)
                    .padding(8)
                    .foregroundColor(selectionIndex == selection ? .systemSegmentButtonAccentColor : .systemSegmentButtonColor)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    @State private var selection = 0

}
