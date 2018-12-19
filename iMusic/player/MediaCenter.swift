//
//  MediaCenter.swift
//  iMusic
//
//  Created by MLeo on 2018/10/26.
//  Copyright © 2018年 回忆中的明天. All rights reserved.
//

import UIKit
import MediaPlayer

class MediaCenter: NSObject {

    var deletgate:ViewDelegate!
    
    
    override init(){
        super.init()
        backgroundProcess()
        setupRemoteTransportControls()
        setupNotifications()
    }
    
    
    func backgroundProcess(){
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options:[])
            try session.setActive(true)
        } catch {
            ToastView(error.localizedDescription)
        }
    }
    
    func setupNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: AVAudioSession.interruptionNotification,
                                       object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            print("began")
            self.deletgate.view(playingByStatus: nil, status: false)
        }else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    print("resume")
                    self.deletgate.view(playingByStatus: nil, status: true)
                }
            }
        }
    }
    
    
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.togglePlayPauseCommand.addTarget { (remoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            try! self.deletgate.view(playOrPauseTrack: nil)
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.addTarget { (remoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            
            if let event = remoteCommandEvent as? MPChangePlaybackPositionCommandEvent {
                self.deletgate.view(endModifyTime: nil, currentTime: event.positionTime)
            }
            return .success
        }
        commandCenter.nextTrackCommand.addTarget { (remoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            try! self.deletgate.view(nextTrack: nil)
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget { (remoteCommandEvent) -> MPRemoteCommandHandlerStatus in
            try! self.deletgate.view(previousTrack: nil)
            return .success
        }
    }
    
    
    func setupNowPlaying(music:MusicView) {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = music.title
        if let data = music.artwork {
            let image = UIImage(data: data)!
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = music.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = music.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = music.isPlaying ?music.playRate:0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = music.isPlaying ? MPNowPlayingPlaybackState.playing : MPNowPlayingPlaybackState.paused
    }
    
    
    
    
}


