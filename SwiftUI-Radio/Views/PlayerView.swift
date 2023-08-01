//
//  PlayerView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import SwiftUI
import MediaPlayer

struct PlayerView: View {
    @EnvironmentObject var storage: StationStorage
    
    @StateObject private var audioHandler = AudioHandler()
                
    @State private var airPlayView = AirPlayView()
    
    @Binding var selectedIndex: Int
    
    private let nowPlayingInfoCenter: MPNowPlayingInfoCenter = .default()
    private let commandCenter: MPRemoteCommandCenter = .shared()
    
    var theme: StationTheme {
        return storage.selectedTheme(selectedIndex)
    }

    var body: some View {
        VStack {
            bufferingView
            progressView
            controlView
        }
        .padding(20)
        .background(Color(hex: theme.firstColor))
        .foregroundColor(Color(hex: theme.secondColor))
        .onChange(of: selectedIndex) { value in
            if let station = storage.stations[value] {
                audioHandler.setupPlayer(station: station)
                setupNowPlaying(station: station)
            }
            airPlayView.color = Color(hex: theme.secondColor)

        }
        .onChange(of: audioHandler.currentTime) { value in
            setCurrentTime(time: value)
        }
        .onChange(of: audioHandler.currentDuration) { value in
            setCurrentDuration(duration: value)
        }
        .onAppear {
            if let station = storage.stations[selectedIndex] {
                audioHandler.setupPlayer(station: station)
                setupNowPlaying(station: station)
            }
            airPlayView.color = Color(hex: theme.secondColor)
            setupRemoteTransportControls()
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
                   .accentColor(Color(hex: theme.secondColor))
                   .foregroundColor(Color(hex: theme.thirdColor))
            
            EqualiserView(animating: audioHandler.isPlaying, color: Color(hex: theme.thirdColor))
                .frame(width: 20, height: 16)
        }
    }
    
    var controlView: some View {
        HStack(spacing: 40) {
            Button(action: {
                storage.markStationAsFavorite(index: selectedIndex)
            }) {
                storage.checkIfStationIsFavorite(index: selectedIndex) ? Image.heartFilled : Image.heart
            }
            .font(.system(size: 24, weight: .regular))
            
            Button(action: {
                audioHandler.isMuted.toggle()
            }) {
                audioHandler.isMuted ? Image.speakerSlashed : Image.speaker
            }
            .font(.system(size: 24, weight: .regular))
            
            Button(action: {
                audioHandler.isPlaying.toggle()
            }) {
                audioHandler.isPlaying ? Image.pause : Image.play
            }
            .font(.system(size: 40, weight: .medium))
            .disabled(audioHandler.isLoading)
            
            Button(action: {
                audioHandler.goToLive()
            }) {
                audioHandler.checkIfIsLive() ? Image.antenna : Image.antennaSlashed
            }
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
                LoaderView(color: Color(hex: theme.thirdColor), message: Constants.buffering)
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
    
    func setupRemoteTransportControls() {
        commandCenter.changePlaybackPositionCommand.addTarget { remoteEvent in
            guard let event = remoteEvent as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            audioHandler.changePlaybackTime(time: event.positionTime)
            return .success
        }
        
        commandCenter.playCommand.addTarget { event in
            audioHandler.isPlaying = true
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            audioHandler.isPlaying = false
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { event in
            selectedIndex = selectedIndex == storage.stations.count-1 ? 0 : selectedIndex+1
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            selectedIndex = selectedIndex == 0 ? storage.stations.count-1 : selectedIndex-1
            return .success
        }
    }
    
    func setupNowPlaying(station: Station) {
        if nowPlayingInfoCenter.nowPlayingInfo == nil {
            nowPlayingInfoCenter.nowPlayingInfo = .init()
        }

        nowPlayingInfoCenter.nowPlayingInfo?[MPMediaItemPropertyTitle] = station.name
        nowPlayingInfoCenter.nowPlayingInfo?[MPMediaItemPropertyArtist] = station.desc
        nowPlayingInfoCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyAssetURL] = station.streamURL

        Utilities.asyncImage(url: station.imageURL) { image in
            guard let image = image else { return }
            let mediaItem = MPMediaItemArtwork(boundsSize: image.size) { _ in
                return image
            }
            nowPlayingInfoCenter.nowPlayingInfo?[MPMediaItemPropertyArtwork] = mediaItem
        }
    }
    
    func setCurrentDuration(duration: Double) {
        nowPlayingInfoCenter.nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = duration
    }
    
    func setCurrentTime(time: Double) {
        nowPlayingInfoCenter.nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time
    }
}

struct PlayerView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    static var previews: some View {
        PlayerView(selectedIndex: $selectedIndex)
            .environmentObject(StationStorage())
    }
}
