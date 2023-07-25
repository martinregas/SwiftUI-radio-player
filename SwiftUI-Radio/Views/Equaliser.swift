//
//  EqualiserView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 20/07/2023.
//

import SwiftUI

//This class was adapted from: https://gist.github.com/CodeSlicing/42fec8137563c9cd7a38d6e2079d109c

struct EqualiserView: View {
    let numBars = 5
    var spacerWidthRatio: CGFloat = 0.2
    
    private var barWidthScaleFactor: CGFloat {
        return 1 / (CGFloat(numBars) + CGFloat(numBars - 1) * spacerWidthRatio)
    }
    
    var animating: Bool = false
    var color: Color
    
    var body: some View {
        GeometryReader { (geo: GeometryProxy) in
            let barWidth = geo.size.width * barWidthScaleFactor
            let spacerWidth = barWidth * spacerWidthRatio
            HStack(spacing: spacerWidth) {
                ForEach(0..<numBars, id: \.self) { index in
                    Bar(minHeightFraction: 0.1, maxHeightFraction: 1, completion: animating ? 1 : 0)
                        .fill(color)
                        .frame(width: barWidth)
                        .animation(animating ? animation : .default, value: animating)
                }
            }
        }
    }
    
    var animation: Animation {
        return .easeInOut(duration: 0.8 + Double.random(in: -0.3...0.3))
            .repeatForever(autoreverses: animating)
            .delay(Double.random(in: 0...0.75))
    }
}


private struct Bar: Shape {
    private let minHeightFraction: CGFloat
    private let maxHeightFraction: CGFloat
    var animatableData: CGFloat
    
    init(minHeightFraction: CGFloat, maxHeightFraction: CGFloat, completion: CGFloat) {
        self.minHeightFraction = minHeightFraction
        self.maxHeightFraction = maxHeightFraction
        self.animatableData = completion
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let heightFractionDelta = maxHeightFraction - minHeightFraction
        let heightFraction = minHeightFraction + heightFractionDelta * animatableData
        
        let rectHeight = rect.height * heightFraction
        
        let rectOrigin = CGPoint(x: rect.minX, y: rect.maxY - rectHeight)
        let rectSize = CGSize(width: rect.width, height: rectHeight)
        
        let barRect = CGRect(origin: rectOrigin, size: rectSize)
        
        path.addRect(barRect)
        
        return path
    }
}
