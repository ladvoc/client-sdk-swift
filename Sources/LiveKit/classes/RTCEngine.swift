//
//  File.swift
//  
//
//  Created by Russell D'Sa on 12/4/20.
//

import Foundation
import WebRTC
import Promises

class RTCEngine: NSObject {
    private var peerConnection: RTCPeerConnection?
    private var client: RTCClient
    private var rtcConnected: Bool = false
    private var iceConnected: Bool = false
    
    private var pendingCandidates: [RTCIceCandidate] = []
    
    var delegate: RTCEngineDelegate?
    
    private static let factory: RTCPeerConnectionFactory = {
        RTCInitializeSSL()
        let videoEncoderFactory = RTCDefaultVideoEncoderFactory()
        let videoDecoderFactory = RTCDefaultVideoDecoderFactory()
        return RTCPeerConnectionFactory(encoderFactory: videoEncoderFactory, decoderFactory: videoDecoderFactory)
    }()
    
    private static let mediaConstraints: RTCMediaConstraints = {
        return RTCMediaConstraints(mandatoryConstraints: nil,
                                   optionalConstraints: ["DtlsSrtpKeyAgreement":kRTCMediaConstraintsValueTrue])
    }()
    
    private static let privateDataChannelLabel = "_private"
    
    init(client: RTCClient) {
        self.client = client
        super.init()
        
        client.delegate = self
        
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: [RTCClient.DefaultSTUNServerHost])]
        // Unified plan is more superior than planB
        config.sdpSemantics = .unifiedPlan
        // gatherContinually will let WebRTC to listen to any network changes and send any new candidates to the other client
        config.continualGatheringPolicy = .gatherContinually
        peerConnection = RTCEngine.factory.peerConnection(with: config, constraints: RTCEngine.mediaConstraints, delegate: self)
        
        /* always have a blank data channel, to ensure there isn't an empty ice-ufrag */
        peerConnection?.dataChannel(forLabel: RTCEngine.privateDataChannelLabel, configuration: RTCDataChannelConfiguration())
    }
    
    func join(roomId: String, options: ConnectOptions) {
        let _ = client.join(roomId: roomId, options: options)
    }
    
    func onRTCConnected() {
        rtcConnected = true
        pendingCandidates.forEach { (candidate) in
            client.sendCandidate(candidate: candidate)
        }
        pendingCandidates.removeAll()
    }
    
    func createOffer() -> Promise<RTCSessionDescription> {
        let promise = Promise<RTCSessionDescription>.pending()
        peerConnection?.offer(for: RTCEngine.mediaConstraints, completionHandler: { (sdp, error) in
            guard error == nil else {
                print("Error creating offer: \(error!)")
                promise.reject(error!)
                return
            }
            promise.fulfill(sdp!)
        })
        
        
        return promise
    }
    
    func negotiate() {
        Promise<RTCSessionDescription> {
            let offer = try await(self.createOffer())
            self.peerConnection?.setLocalDescription(offer, completionHandler: { error in
                guard error == nil else {
                    print("Error setting local description for offer: \(offer)")
                    return
                }
                self.client.sendNegotiate(sdp: offer)
            })
        }.catch { error in
            print("Error during negotation")
        }
    }
}

extension RTCEngine: RTCClientDelegate {
    func onJoin(info: Livekit_JoinResponse) {
        delegate?.didJoin(response: info)
        peerConnection?.offer(for: RTCEngine.mediaConstraints, completionHandler: { (sdp, error) in
            guard error == nil else {
                print("Error: \(error!)")
                return
            }
            self.peerConnection?.setLocalDescription(sdp!, completionHandler: { error in
                guard error == nil else {
                    print("Error setting local description: \(error!)")
                    return
                }
                self.client.sendOffer(sdp: sdp!)
            })
        })
    }
    
    func onAnswer(sessionDescription: RTCSessionDescription) {
        peerConnection!.setRemoteDescription(sessionDescription) { error in
            guard error == nil else {
                print("Error setting remote description: \(error!)")
                return
            }
            
        }
    }
    
    func onTrickle(candidate: RTCIceCandidate) {
        print("Received ICE candidate from peer: \(candidate)")
        peerConnection!.add(candidate)
    }
    
    func onNegotiate(sessionDescription: RTCSessionDescription) {
        print("Received negotiate: \(sessionDescription)")
        peerConnection?.setRemoteDescription(sessionDescription)
        if sessionDescription.type == .offer {
            peerConnection?.answer(for: RTCEngine.mediaConstraints, completionHandler: { (sdp, error) in
                guard error == nil else {
                    print("Error sending answer: \(error!)")
                    return
                }
                self.peerConnection?.setLocalDescription(sdp!)
                self.client.sendNegotiate(sdp: sdp!)
            })
        }
    }
    
    func onParticipantUpdate(updates: [Livekit_ParticipantInfo]) {
        print("Received participant update")
        delegate?.didUpdateParticipants(updates: updates)
    }
    
    func onClose(reason: String) {
        print("Received close event: \(reason)")
        delegate?.didDisconnect(error: nil)
    }
    
    func onError(error: Error) {
        print("Error: \(error)")
        delegate?.didDisconnect(error: error)
    }
}

extension RTCEngine: RTCPeerConnectionDelegate {
    func peerConnectionShouldNegotiate(_ peerConnection: RTCPeerConnection) {
        guard rtcConnected else {
            return
        }
        negotiate()
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove stream: RTCMediaStream) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceConnectionState) {
        if peerConnection.iceConnectionState == .connected {
            iceConnected = true
        }
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange newState: RTCIceGatheringState) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didGenerate candidate: RTCIceCandidate) {
        print("Adding ICE candidate for peer: \(candidate)")
        rtcConnected ? client.sendCandidate(candidate: candidate) : pendingCandidates.append(candidate)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didRemove candidates: [RTCIceCandidate]) {
        
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didOpen dataChannel: RTCDataChannel) {
        delegate?.didAddDataChannel(channel: dataChannel)
    }
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd rtpReceiver: RTCRtpReceiver, streams mediaStreams: [RTCMediaStream]) {
        if let track = rtpReceiver.track {
            delegate?.didAddTrack(track: track, streams: mediaStreams)
        }
    }
}