//
//  StationSelectorView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 20/07/2023.
//

import SwiftUI

struct StationSelectorView: View {
    @EnvironmentObject var storage: StationStorage
    
    @Binding var selectedIndex: Int
    
    @State private var snappedItem = 0.0
    @State private var draggingItem = 0.0
    
    @State private var showingDetails = false
        
    var body: some View {
        VStack {
            ZStack {
                ForEach(Array(storage.stations.enumerated()), id: \.element) { index, item in
                    VStack {
                        AsyncImage(url: URL(string: item.imageURL), content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }, placeholder: {
                            ProgressView()
                        })
                        
                        if showingDetails && index == selectedIndex {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(item.name)
                                    .font(.system(size: 14, weight: .bold))
                                Text(item.desc)
                                    .font(.system(size: 14, weight: .regular))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom ,20)
                            .padding(.horizontal ,20)
                        }
                    }
                    .background(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, showingDetails ? 0 : 20)
                    .scaleEffect(1.0 - abs(distance(index)) * 0.2)
                    .opacity(1.0 - abs(distance(index)) * 0.3)
                    .offset(x: xOffset(index), y: 0)
                    .zIndex(1.0 - abs(distance(index)) * 0.1)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onTapGesture(count: 1) {
            withAnimation(.linear(duration: 0.5)) {
                showingDetails.toggle()
            }
        }
        .gesture(dragGesture)
    }
    
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if !showingDetails {
                    draggingItem = snappedItem + value.translation.width / 100
                }
            }
            .onEnded { value in
                if !showingDetails {
                    withAnimation {
                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
                        draggingItem = round(draggingItem).remainder(dividingBy: Double(storage.stations.count))
                        snappedItem = draggingItem
                        
                        selectedIndex = storage.stations.count + Int(draggingItem)
                        if selectedIndex > storage.stations.count || Int(draggingItem) >= 0 {
                            withAnimation {
                                selectedIndex = Int(draggingItem)
                            }
                        }
                    }
                }
            }
    }
    
    func distance(_ item: Int) -> Double {
        return (draggingItem - Double(item)).remainder(dividingBy: Double(storage.stations.count))
    }
    
    func xOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(storage.stations.count) * distance(item)
        return sin(angle) * 200
    }
}

struct StationSelectorView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    static var previews: some View {
        StationSelectorView(selectedIndex: $selectedIndex)
            .environmentObject(StationStorage())
    }
}
