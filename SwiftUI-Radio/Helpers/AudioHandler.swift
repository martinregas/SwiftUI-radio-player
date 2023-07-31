//
//  AudioHandler.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import SwiftUI
import AVFoundation

class AudioHandler: NSObject, ObservableObject {
    @Published var isPlaying: Bool = false {
        willSet {
            newValue ? player.play() : player.pause()
        }
    }
    @Published var isMuted: Bool = false {
        willSet {
            player.isMuted =  newValue
        }
    }
    @Published var isLoading: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var currentDuration: TimeInterval = 0
        
    private var player: AVPlayer = .init()
    private var timeObserverPaused = false
            
    override init() {
        super.init()
        setupPlayerObserver()
    }

    func setupPlayerObserver() {
        player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            
            if let playerItem = player.currentItem, playerItem.status == .readyToPlay {
                let timeRange = playerItem.loadedTimeRanges[0].timeRangeValue
                let seconds = TimeInterval(timeRange.duration.seconds-5)
                currentDuration = seconds < 0 ? 0 : seconds
            }
            
            if !self.timeObserverPaused {
                currentTime = time.seconds < 0 ? 0 : time.seconds
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if let status = player.currentItem?.status.rawValue, status == 1 {
                isLoading = false
            }
        }
    }

    func setupPlayer(station: Station) {
        guard let url = URL(string: station.streamURL) else { return }
        
        isPlaying = false
        isLoading = true

        currentDuration = 0
        currentTime = 0
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.currentItem?.preferredForwardBufferDuration = TimeInterval(10000)
        player.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)        
    }
    
    func changingPlaybackTime(editingStarted: Bool) {
        if editingStarted {
            timeObserverPaused = true
            return
        }
        changePlaybackTime(time: currentTime)
    }
    
    func goToLive() {
        if checkIfIsLive() { return }
        currentTime = currentDuration
        changingPlaybackTime(editingStarted: false)
    }
    
    func checkIfIsLive() -> Bool {
        return currentTime >= (currentDuration-2) && currentDuration != 0.0
    }

    func changePlaybackTime(time: Double) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 600)
        player.seek(to: targetTime) { [weak self] time in
            self?.timeObserverPaused = false
        }
    }
}

