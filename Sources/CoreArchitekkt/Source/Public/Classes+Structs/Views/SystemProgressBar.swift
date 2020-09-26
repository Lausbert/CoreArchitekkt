// Copyright © 2020 Stephan Lerner. All rights reserved.

import SwiftUI

public struct SystemProgressBar: View {
    
    // MARK: - Public -
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .strokeBorder(Color.systemProgressBarBackgroundStrokeColor, lineWidth: 1)
                    .background(Color.systemProgressBarBackgroundColor)
                Capsule()
                    .fill(Color.accentColor)
                    .frame(width: SystemProgressBar.widthFactor*geometry.size.width)
                    .modifier(
                        SpringOffset(
                            offset: isMovingRight ? SystemProgressBar.height - SystemProgressBar.widthFactor*geometry.size.width : geometry.size.width - SystemProgressBar.height,
                            pct: isMovingRight ? 0 : 1,
                            isMovingRight: isMovingRight
                        ))
                    .onReceive(timer) { _ in
                        withAnimation(Animation.easeInOut(duration: SystemProgressBar.duration)) {
                            self.isMovingRight.toggle()
                        }
                    }
            }.onAppear() {
                withAnimation(Animation.easeInOut(duration: SystemProgressBar.duration)) {
                    self.isMovingRight.toggle()
                }
            }
        }
        .frame(height: SystemProgressBar.height)
        .clipShape(Capsule())
    }
    
    // MARK: - Private -
    
    private static let duration: Double = 1.35
    private static let widthFactor: CGFloat = 0.25
    private static let height: CGFloat = 6.0
    
    private let timer = Timer.publish(every: SystemProgressBar.duration, on: .main, in: .common).autoconnect()
        
    @State private var isMovingRight = true
    
    private struct SpringOffset: GeometryEffect {
        var offset: CGFloat
        var pct: CGFloat
        var isMovingRight: Bool

        var animatableData: AnimatablePair<CGFloat, CGFloat> {
            get { return AnimatablePair<CGFloat, CGFloat>(offset, pct) }
            set {
                isMovingRight.toggle()
                offset = newValue.first
                pct = newValue.second
            }
        }

        func effectValue(size: CGSize) -> ProjectionTransform {
            let pct = isMovingRight ? self.pct : 1 - self.pct
            let scale = 1 + 2*pct*(pct-0.8)*(pct-1)
            return ProjectionTransform(CGAffineTransform(a: scale, b: 0, c: 0, d: 1, tx: offset + (1-scale)/2*size.width, ty: 0))
        }
    }
}
