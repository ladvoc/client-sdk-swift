//
//  AudioCapturer.swift
//  LiveKit
//
//  Created by Jacob Gelman on 2/8/25.
//

internal import LiveKitWebRTC

protocol AudioCapturerProtocol {
    var audioDeviceModule: LKRTCAudioDeviceModule { get }
}

class AudioCapturer: LKRTCAudioSource {
    
    var audioDeviceModule = LKRTCAudioDeviceModule()
    
    func a() {
        
    }
}
