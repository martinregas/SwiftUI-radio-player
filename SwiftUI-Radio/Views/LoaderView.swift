//
//  LoaderView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 20/07/2023.
//

import SwiftUI

struct LoaderView: View {
    var shouldAnimate = false
    var color: Color
    var message: String
    
    var body: some View {
        HStack {
            Text(message)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(color)
            DotView(color: color)
            DotView(delay: 0.2, color: color)
            DotView(delay: 0.4, color: color)
        }
    }
    
    struct DotView: View {
        @State var delay: Double = 0
        @State var scale: CGFloat = 0.5
        var color: Color
        
        var body: some View {
            Circle()
                .frame(width: 6, height: 6)
                .scaleEffect(scale)
                .animation(animation, value: scale)
                .foregroundColor(color)
                .onAppear {
                    withAnimation {
                        scale = 1
                    }
                }
        }
        
        var animation: Animation {
            Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(color: .black, message: Constants.buffering)
    }
}


struct DotView: View {
    @State var delay: Double = 0
    @State var scale: CGFloat = 0.5
    var body: some View {
        Circle()
            .frame(width: 6, height: 6)
            .scaleEffect(scale)
            .animation(animation, value: scale)
            .onAppear {
                withAnimation {
                    scale = 1
                }
            }
    }
    
    var animation: Animation {
        Animation.easeInOut(duration: 0.6).repeatForever().delay(delay)
    }
}
