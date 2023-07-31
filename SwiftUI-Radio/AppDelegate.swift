//
//  AppDelegate.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 31/07/2023.
//

import AVKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            
        configureAudioSession()

        return true
    }
    
    private func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowAirPlay, .allowBluetoothA2DP])
        } catch(let error) {
            print(error)
        }
    }
}
