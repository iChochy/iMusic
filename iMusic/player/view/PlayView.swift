//
//  PlayVIew.swift
//  SwiftCode
//
//  Created by MLeo on 2018/10/24.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class PlayView: UIView {

    var delegate:PlayViewDelegate!
    
    var closeButton:UIButton!

    var imageView:UIImageView!
    
    var slider:UISlider!
    
    var startTimeLabel:UILabel!
    var endTimeLabel:UILabel!
    
    var titleLabel:UILabel!
    var descriptionLabel:UILabel!
    
    var previousButton:UIButton!
    var playButton:UIButton!
    var nextButton:UIButton!
    
    var rateButton:UIButton!
    
    var totalTime:Int = 0
    var playStatus:Int = 1
    
    init(parent:UIView){
        super.init(frame: parent.frame)
        self.backgroundColor = UIColor.white
        
        createCloseButton()
        createImageView()
        createSlider()
        createStartTimeLabel()
        createEndTimeLabel()
        createTitleLabel()
        createDescriptionLabel()
        createPlayButton()
        createPreviousButton()
        createNextButton()
        createRateButton()
        self.isHidden = true
        parent.addSubview(self)
        addPlayViewConstraint(child: self, parent: parent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateProgress(currentTime:Int){
        timeUpdate(currentTime: currentTime)
        sliderUpdate(currentTime: currentTime)
    }
    
    func timeUpdate(currentTime:Int){
        let start = Utils.formatDuration(duration: currentTime)
        let endTime = totalTime - currentTime
        let end = Utils.formatDuration(duration: endTime)
        startTimeLabel.text = "\(start)"
        endTimeLabel.text = "-\(end)"
    }
    
    func sliderUpdate(currentTime:Int){
        slider.setValue(Float(currentTime), animated: true)
    }
    
    
    func load(music:MusicEntity){
        imageView.image = music.artwork
        startTimeLabel.text = "00:00"
        totalTime = music.duration!
        slider.setValue(0, animated: false)
        slider.minimumValue = 0
        slider.maximumValue = Float(totalTime)
        let endTime = Utils.formatDuration(duration: totalTime)
        endTimeLabel.text = "-\(endTime)"
        titleLabel.text = music.title ?? "iMusic"
        descriptionLabel.text = "\(music.artist ?? "--") - \(music.albumName ?? "--")"
        self.isHidden = false
    }
    
    
    func play(music:MusicEntity){
        load(music: music)
        playButton.setImage(UIImage(named: "暂停"), for: .normal)
    }
    

    func createCloseButton(){
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "下拉"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        self.addSubview(closeButton)
        addCloseButtonConstraint(child: closeButton, parent: self)
    }
    
    func addCloseButtonConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 20),
                child.heightAnchor.constraint(equalToConstant: 20),
                child.topAnchor.constraint(equalTo: parent.topAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
    
    func createRateButton(){
        rateButton  = UIButton()
        rateButton.setImage(UIImage(named: "1.0-火箭"), for: .normal)
        rateButton.addTarget(self, action: #selector(modifyPlayRate), for: .touchUpInside)
        self.addSubview(rateButton)
        addRateButtonConstraint(child: rateButton, parent: playButton)
    }
    
    
    func addRateButtonConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 35),
                child.heightAnchor.constraint(equalToConstant: 35),
                child.topAnchor.constraint(greaterThanOrEqualTo: parent.bottomAnchor, constant: 5),
                child.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor)
            ]
        )
    }
    
    
    func createTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "--"
        self.addSubview(titleLabel)
        addTitleLabelConstraint(child: titleLabel, parent: startTimeLabel)
    }
    
    func addTitleLabelConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
    func createDescriptionLabel(){
        descriptionLabel = UILabel()
        descriptionLabel.text = "--"
        self.addSubview(descriptionLabel)
        addTitleLabelConstraint(child: descriptionLabel, parent: titleLabel)
    }
    
    func addDescriptionLabelConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
    
    func createPlayButton(){
        playButton = UIButton()
        playButton.setImage(UIImage(named: "播放"), for: .normal)
        playButton.addTarget(self, action: #selector(pauseOrPlay), for: .touchUpInside)
        self.addSubview(playButton)
        addPlayButtonConstraint(child: playButton, parent: descriptionLabel)
    }
    
    func addPlayButtonConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 40),
                child.heightAnchor.constraint(equalToConstant: 40),
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
    
    func createPreviousButton(){
        previousButton = UIButton()
        previousButton.setImage(UIImage(named: "上一首"), for: .normal)
        previousButton.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        self.addSubview(previousButton)
        addPreviousButtonConstraint(child: previousButton, parent: playButton)
    }
    
    func addPreviousButtonConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 30),
                child.heightAnchor.constraint(equalToConstant: 30),
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                parent.leadingAnchor.constraint(equalTo: child.trailingAnchor, constant: 25)
            ]
        )
    }
    
    func createNextButton(){
        nextButton = UIButton()
        nextButton.setImage(UIImage(named: "下一首"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        self.addSubview(nextButton)
        addNextButtonConstraint(child: nextButton, parent: playButton)
    }
    
    func addNextButtonConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 30),
                child.heightAnchor.constraint(equalToConstant: 30),
                child.centerYAnchor.constraint(equalTo: parent.centerYAnchor),
                child.leadingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 25)
            ]
        )
    }
    
    func createStartTimeLabel(){
        startTimeLabel = UILabel()
        startTimeLabel.text = "--:--"
        self.addSubview(startTimeLabel)
        addStartTimeLabelConstraint(child: startTimeLabel, parent: slider)
    }
    
    func addStartTimeLabelConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 2),
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor)
            ]
        )
    }
    
    
    func createEndTimeLabel(){
        endTimeLabel = UILabel()
        endTimeLabel.text = "--:--"
        self.addSubview(endTimeLabel)
        addEndTimeLabelConstraint(child: endTimeLabel, parent: slider)
    }
    
    func addEndTimeLabelConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 2),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ]
        )
    }
    
    
    func createSlider(){
        slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.tintColor = UIColor.darkText
        slider.setValue(0, animated: false)

        
        slider.addTarget(self, action: #selector(modifyTime(slider:)), for: .valueChanged)
        
        slider.addTarget(self, action: #selector(startModifyTime(slider:)), for: .touchDown)
        
        slider.addTarget(self, action: #selector(endModifyTime(slider:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endModifyTime(slider:)), for: .touchUpOutside)
        
        
        self.addSubview(slider)
        addSliderConstraint(child: slider, parent: imageView)
    }
    
    func addSliderConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
            ]
        )
    }
    
    
    func createImageView(){
        imageView = UIImageView(image: UIImage(named: "Image"))
        self.addSubview(imageView)
        addImageViewConstraint(child: imageView, parent: closeButton)
    }
    
    
    func addImageViewConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.widthAnchor.constraint(equalToConstant: 250),
                child.heightAnchor.constraint(equalToConstant: 250),
                child.topAnchor.constraint(equalTo: parent.bottomAnchor, constant: 5),
                child.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        )
    }
    
    
    func addPlayViewConstraint(child:UIView,parent:UIView){
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
                child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
                child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
                child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
            ]
        )
    }
    
    @objc func closeView(){
       self.isHidden = true
    }
    
    @objc func modifyPlayRate(){
        let playRate = delegate.playView(modifyPlayRate: self)
        rateButton.setImage(UIImage(named: "\(playRate)-火箭"), for: .normal)
    }
    
    @objc func endModifyTime(slider:UISlider){
        delegate.playView(endModifyTime: self, seek: Int(slider.value))
    }
    
    
    @objc func modifyTime(slider:UISlider){
        self.updateProgress(currentTime: Int(slider.value))
    }
    
    @objc func startModifyTime(slider:UISlider){
        delegate.playView(startModifyTime: self)
    }
    
    
    @objc func previousTrack(){
        let music = delegate.playView(previousTrack: self)
        load(music: music)

    }
    
    @objc func nextTrack(){
        let music = delegate.playView(nextTrack: self)
        load(music: music)

    }
    
    
    @objc func pauseOrPlay(){
        if playStatus == 1 {
            pauseTrack()
        }else{
            playTrack()
        }
    }
    
    func playTrack(){
        playStatus = 1
        delegate.playView(playTrack: self)
        playButton.setImage(UIImage(named: "暂停"), for: .normal)
    }
    
    func pauseTrack(){
        playStatus = 0
        delegate.playView(pauseTrack: self)
        playButton.setImage(UIImage(named: "播放"), for: .normal)
    }

    
}
