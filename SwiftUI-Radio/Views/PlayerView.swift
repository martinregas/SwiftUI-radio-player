//
//  PlayerView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @EnvironmentObject var storage: StationStorage
    
    @StateObject var audioHandler = AudioHandler()
        
    @Binding var selectedIndex: Int
    
    var url: String = String()
    
    @State private var airPlayView = AirPlayView()

    
    var body: some View {
        VStack {
            bufferingView
            VStack(spacing: 10) {
                progressView
                controlView
            }
        }
        .padding(20)
        .background(Color(hex: storage.selectedTheme(selectedIndex).firstColor))
        .foregroundColor(Color(hex: storage.selectedTheme(selectedIndex).secondColor))
        .onChange(of: selectedIndex, perform: { value in
            audioHandler.setupPlayer(url: storage.stations[value].streamURL)
            audioHandler.currentDuration = 0
            audioHandler.currentTime = 0
            airPlayView.color = Color(hex: storage.selectedTheme(selectedIndex).secondColor)
        })
        .onAppear {
            if let streamURL = storage.stations.first?.streamURL {
                audioHandler.setupPlayer(url: streamURL)
            }
            airPlayView.color = Color(hex: storage.selectedTheme(selectedIndex).secondColor)
        }
    }
    
    var progressView: some View {
        HStack(alignment: .center, spacing: 10) {
            Slider(value: $audioHandler.currentTime,
                   in: 0...audioHandler.currentDuration,
                   onEditingChanged: sliderEditingChanged,
                   minimumValueLabel: Text(minimumValueText),
                   maximumValueLabel: Text(maximumValueText)) {}
                   .disabled(audioHandler.isLoading)
                   .accentColor(Color(hex: storage.selectedTheme(selectedIndex).secondColor))
                   .foregroundColor(Color(hex: storage.selectedTheme(selectedIndex).thirdColor))
            
            EqualiserView(animating: audioHandler.isPlaying, color: Color(hex: storage.selectedTheme(selectedIndex).thirdColor))
                .frame(width: 20, height: 16)
        }
    }
    
    var controlView: some View {
        HStack(spacing: 40) {
            Button(action: {
                storage.markStationAsFavorite(index: selectedIndex)
            }, label: {
                storage.checkIfStationIsFavorite(index: selectedIndex) ? Image.heartFilled : Image.heart
            })
            .font(.system(size: 24, weight: .regular))
            
            Button(action: {
                audioHandler.isMuted.toggle()
            }, label: {
                audioHandler.isMuted ? Image.speakerSlashed : Image.speaker
            })
            .font(.system(size: 24, weight: .regular))
            
            Button(action: {
                audioHandler.isPlaying.toggle()
            }, label: {
                audioHandler.isPlaying ? Image.pause : Image.play
            })
            .font(.system(size: 40, weight: .medium))
            .disabled(audioHandler.isLoading)
            
            Button(action: {
                audioHandler.goToLive()
            }, label: {
                audioHandler.checkIfIsLive() ? Image.antenna : Image.antennaSlashed
            })
            .font(.system(size: 20, weight: .medium))
            .disabled(audioHandler.isLoading)
            
            Button(action: {
                airPlayView.showAirPlayMenu()
            }) {
                airPlayView
            }
            .frame(width: 30, height: 30)
        }
        .frame(maxHeight: 30)
    }
    
    var bufferingView: some View {
        VStack {
            if audioHandler.isLoading {
                LoaderView(color: Color(hex: storage.selectedTheme(selectedIndex).thirdColor), message: Constants.buffering)
            }
        }
        .frame(height: 12)
    }
    
    var minimumValueText: String {
        return audioHandler.checkIfIsLive() ? Constants.live : Utilities.formatSecondsToHMS(audioHandler.currentTime)
    }
    
    var maximumValueText: String {
        return Utilities.formatSecondsToHMS(audioHandler.currentDuration)
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        audioHandler.changingPlaybackTime(editingStarted: editingStarted)
    }
}

struct PlayerView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    static var previews: some View {
        PlayerView(selectedIndex: $selectedIndex)
            .environmentObject(StationStorage())
    }
}
