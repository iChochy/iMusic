//
//  MediaCenter.swift
//  iMusic
//
//  Created by MLeo on 2018/10/26.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit
import MediaPlayer


class MediaCenter: NSObject {

    var deletgate:MediaCenterDelegate!
    
    
    override init(){
        super.init()
        backgroundProcess()
        setupRemoteTransportControls()
//        setupNotifications()
    }
    
    
    func backgroundProcess(){
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options:[])
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: AVAudioSession.interruptionNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(playToEndTime),
                                       name: .AVPlayerItemDidPlayToEndTime,
                                       object: nil)
    }
    
    @objc func playToEndTime(notification:Notification){
        self.deletgate.mediaCenter(nextTrack: "nil")
        self.deletgate.mediaCenter(playTrack: "nil")
    }
    
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            self.deletgate.mediaCenter(pauseTrack: nil)
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    self.deletgate.mediaCenter(playTrack: "nil")
                }
            }
        }
    }
    
    
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.deletgate.mediaCenter(playTrack: "nil")
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.deletgate.mediaCenter(pauseTrack: "nil")
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.deletgate.mediaCenter(nextTrack: "nil")
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            self.deletgate.mediaCenter(previousTrack: "nil")
            return .success
        }
    }
    
    
    func setupNowPlaying(music:MusicEntity) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = music.title
        if let image = music.artwork {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = music.backTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = music.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = music.playRate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    
}


