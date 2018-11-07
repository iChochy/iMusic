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
    
    var beganPoint:CGPoint!
    var movePoint:CGPoint!
    
    var totalTime:Double = 0
    var playStatus:Int = 1
    let toolBarHeight:CGFloat = 100
    
    var playerViewTopAnchor:NSLayoutConstraint!
    
    var displayConstraints:[NSLayoutConstraint] = []
    var hiddenConstraints:[NSLayoutConstraint] = []
    
    init(parent:UIView){
        super.init(frame: parent.frame)
        self.backgroundColor = UIColor.white
        self.round(byRoundingCorners: [.topLeft,.topRight], cornerRadii: 10)
        
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
        self.backgroundColor = UIColor.lightGray
        self.translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        addPlayViewConstraint(item: self, toItem: parent)
        addDisplayConstraint()
        addHiddenConstraint()
        NSLayoutConstraint.activate(hiddenConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    func addPlayViewConstraint(item:UIView,toItem:UIView){
        let height = UIScreen.main.bounds.height
        let barHeight = UIApplication.shared.statusBarFrame.height
        playerViewTopAnchor = item.topAnchor.constraint(equalTo: toItem.topAnchor, constant: height-toolBarHeight) as NSLayoutConstraint
        NSLayoutConstraint.activate(
            [
                playerViewTopAnchor,
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: toItem.trailingAnchor),
                item.heightAnchor.constraint(equalToConstant: height-barHeight-10)
            ]
        )
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
        diplayPlayerView()
    }
    

    
    func play(music:MusicEntity){
        load(music: music)
        playButton.setImage(UIImage(named: "暂停"), for: .normal)
    }
    
    
    //创建UIView
    ///////////////////////////////////////////////////////////////////
    
    func createCloseButton(){
        closeButton = UIButton()
        closeButton.setImage(UIImage(named: "下拉"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(closeButton)
        
    }
    
    func createImageView(){
        imageView = UIImageView(image: UIImage(named: "CD"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
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
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(slider)
    }
    
    func createStartTimeLabel(){
        startTimeLabel = UILabel()
        startTimeLabel.text = "--:--"
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(startTimeLabel)
        
    }
    
    func createEndTimeLabel(){
        endTimeLabel = UILabel()
        endTimeLabel.text = "--:--"
        endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(endTimeLabel)
        
    }
    func createTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "--"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
    }

    func createDescriptionLabel(){
        descriptionLabel = UILabel()
        descriptionLabel.text = "--"
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        
    }
    func createPlayButton(){
        playButton = UIButton()
        playButton.setImage(UIImage(named: "播放"), for: .normal)
        playButton.addTarget(self, action: #selector(pauseOrPlay), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(playButton)
        
    }
    func createPreviousButton(){
        previousButton = UIButton()
        previousButton.setImage(UIImage(named: "上一首"), for: .normal)
        previousButton.addTarget(self, action: #selector(previousTrack), for: .touchUpInside)
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(previousButton)
        
    }
    func createNextButton(){
        nextButton = UIButton()
        nextButton.setImage(UIImage(named: "下一首"), for: .normal)
        nextButton.addTarget(self, action: #selector(nextTrack), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nextButton)
    }
    

    func createRateButton(){
        rateButton  = UIButton()
        rateButton.setImage(UIImage(named: "1.0-火箭"), for: .normal)
        rateButton.addTarget(self, action: #selector(modifyPlayRate), for: .touchUpInside)
        rateButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rateButton)
    }
    
    
    
    
    //添加显示约束
    //////////////////////////////////////////////////////////////////////
    
    func addDisplayConstraint(){
        let closeButtonConstraint = displayCloseButtonConstraint(item: closeButton, toItem: self)
        let rateButtonConstraint = displayRateButtonConstraint(itme: rateButton, toItem: playButton)
        let titleLabelConstraint = displayTitleLabelConstraint(item: titleLabel, toItem: startTimeLabel)
        let descriptionLabelConstraint = displayDescriptionLabelConstraint(item: descriptionLabel, toItem: titleLabel)
        let playButtonConstraint = displayPlayButtonConstraint(item: playButton, toItem: descriptionLabel)
        let previousButtonConstraint = displayPreviousButtonConstraint(item: previousButton, toItem: playButton)
        let nextButtonConstraint = displayNextButtonConstraint(item: nextButton, toItem: playButton)
        let startTimeLabelConstraint = displayStartTimeLabelConstraint(item: startTimeLabel, toItem: slider)
        let endTimeLabelConstraint = displayEndTimeLabelConstraint(item: endTimeLabel, toItem: slider)
        let sliderConstraint = displaySliderConstraint(item: slider, toItem: imageView)
        let imageViewConstraint = displayImageViewConstraint(item: imageView, toItem: closeButton)
        
        displayConstraints.append(contentsOf: closeButtonConstraint)
        displayConstraints.append(contentsOf: rateButtonConstraint)
        displayConstraints.append(contentsOf: titleLabelConstraint)
        displayConstraints.append(contentsOf: descriptionLabelConstraint)
        displayConstraints.append(contentsOf: playButtonConstraint)
        displayConstraints.append(contentsOf: previousButtonConstraint)
        displayConstraints.append(contentsOf: nextButtonConstraint)
        displayConstraints.append(contentsOf: startTimeLabelConstraint)
        displayConstraints.append(contentsOf: endTimeLabelConstraint)
        displayConstraints.append(contentsOf: sliderConstraint)
        displayConstraints.append(contentsOf: imageViewConstraint)
    }

    func displayCloseButtonConstraint(item:UIView,toItem:UIView) -> [NSLayoutConstraint]{
        item.widthAnchor.constraint(equalToConstant: 20).isActive = true
        item.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.topAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        return constraint
    }
    
    func displayImageViewConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.widthAnchor.constraint(equalToConstant: 250),
                item.heightAnchor.constraint(equalToConstant: 250),
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        return constraint
    }
    

    func displaySliderConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: toItem.centerXAnchor),
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor),
                item.trailingAnchor.constraint(equalTo: toItem.trailingAnchor)
        ]
        return constraint
    }
    
    func displayStartTimeLabelConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 2),
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor)
        ]
        return constraint
    }
    
    
    func displayEndTimeLabelConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 2),
                item.trailingAnchor.constraint(equalTo: toItem.trailingAnchor)
        ]
        return constraint
    }

    
    func displayTitleLabelConstraint(item:UIView,toItem:UIView) -> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        return constraint
    }
    
    func displayDescriptionLabelConstraint(item:UIView,toItem:UIView) -> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        return constraint
    }
    
    func displayPlayButtonConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        item.widthAnchor.constraint(equalToConstant: 40).isActive = true
        item.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let constraint:[NSLayoutConstraint] =
            [
                item.topAnchor.constraint(equalTo: toItem.bottomAnchor, constant: 5),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ]
        return constraint
    }

    func displayPreviousButtonConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        item.widthAnchor.constraint(equalToConstant: 30).isActive = true
        item.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let constraint:[NSLayoutConstraint] =
            [
                
                item.centerYAnchor.constraint(equalTo: toItem.centerYAnchor),
                toItem.leadingAnchor.constraint(equalTo: item.trailingAnchor, constant: 25)
            ]
        return constraint
    }
    
    func displayNextButtonConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        item.widthAnchor.constraint(equalToConstant: 30).isActive = true
        item.heightAnchor.constraint(equalToConstant: 30).isActive = true
        let constraint:[NSLayoutConstraint] =
            [
                item.centerYAnchor.constraint(equalTo: toItem.centerYAnchor),
                item.leadingAnchor.constraint(equalTo: toItem.trailingAnchor, constant: 25)
            ]
        return constraint
    }
    
    func displayRateButtonConstraint(itme:UIView,toItem:UIView) -> [NSLayoutConstraint]{
        itme.widthAnchor.constraint(equalToConstant: 35).isActive = true
        itme.heightAnchor.constraint(equalToConstant: 35).isActive = true
        let constraint:[NSLayoutConstraint] =
            [
                itme.topAnchor.constraint(greaterThanOrEqualTo: toItem.bottomAnchor, constant: 5),
                itme.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                itme.centerXAnchor.constraint(equalTo: toItem.centerXAnchor)
        ]
        return constraint
    }
    

    

    
    //添加隐藏约言束
    ///////////////////////////////////////////
    
    func addHiddenConstraint(){
        let imageViewConstraint = hiddenImageViewConstraint(item: imageView, toItem: self)
        let titleLabelConstraint = hiddenTitleLabelConstraint(item: titleLabel, toItem: imageView)
        let playButtonConstraint = hiddenPlayButtonConstraint(item: playButton, toItem: imageView)
        let otherConstraint = hiddenOtherConstraint()
        
        hiddenConstraints.append(contentsOf: imageViewConstraint)
        hiddenConstraints.append(contentsOf: titleLabelConstraint)
        hiddenConstraints.append(contentsOf: playButtonConstraint)
        hiddenConstraints.append(contentsOf: otherConstraint)
    }
    
    func hiddenImageViewConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.widthAnchor.constraint(equalToConstant: toolBarHeight),
                item.heightAnchor.constraint(equalToConstant: toolBarHeight),
                item.topAnchor.constraint(equalTo: toItem.topAnchor),
                item.leadingAnchor.constraint(equalTo: toItem.leadingAnchor)
        ]
        return constraint
    }
    
    func hiddenTitleLabelConstraint(item:UIView,toItem:UIView) -> [NSLayoutConstraint]{
        
        let constraint:[NSLayoutConstraint] =
            [
                item.centerYAnchor.constraint(equalTo: toItem.centerYAnchor),
                item.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ]
        return constraint
    }
    
    func hiddenPlayButtonConstraint(item:UIView,toItem:UIView)-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                item.centerYAnchor.constraint(equalTo: toItem.centerYAnchor),
                item.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:-20)
        ]
        return constraint
    }
    func hiddenOtherConstraint()-> [NSLayoutConstraint]{
        let constraint:[NSLayoutConstraint] =
            [
                closeButton.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                slider.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                slider.widthAnchor.constraint(equalToConstant: slider.frame.width),
                startTimeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                endTimeLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                descriptionLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                previousButton.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                nextButton.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                rateButton.topAnchor.constraint(equalTo: self.topAnchor,constant: toolBarHeight),
                
                closeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                slider.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                startTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                endTimeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                previousButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                nextButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                rateButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                
        ]
        return constraint
    }

    
    //事件响应
    //////////////////////////////////////////////////////////
    @objc func closeView(){
        hiddenPlayerView()
    }
    
    @objc func modifyPlayRate(){
        let playRate = delegate.playView(modifyPlayRate: self)
        rateButton.setImage(UIImage(named: "\(playRate)-火箭"), for: .normal)
    }
    
    @objc func endModifyTime(slider:UISlider){
        delegate.playView(endModifyTime: self, seek: Double(slider.value))
    }
    
    
    @objc func modifyTime(slider:UISlider){
        self.updateProgress(currentTime: Double(slider.value))
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

    
    //界面操作
    /////////////////////////////////////////////////
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

    
    func updateProgress(currentTime:Double){
        timeUpdate(currentTime: currentTime)
        sliderUpdate(currentTime: currentTime)
    }
    
    func timeUpdate(currentTime:Double){
        let start = Utils.formatDuration(duration: currentTime)
        let endTime = totalTime - currentTime
        let end = Utils.formatDuration(duration: endTime)
        startTimeLabel.text = "\(start)"
        endTimeLabel.text = "-\(end)"
    }
    
    func sliderUpdate(currentTime:Double){
        slider.setValue(Float(currentTime), animated: true)
    }
    
    
    
    //滑动播放界面
    //////////////////////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point = touch.location(in: self.superview)
            beganPoint = point
            movePoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let point =  touch.location(in: self.superview)
            if beganPoint.y >= point.y {
                return
            }
            let value = movePoint.y - point.y
            playerViewTopAnchor.constant = playerViewTopAnchor.constant -  value
            movePoint = point
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let endPoint = touch.location(in: self.superview)
            if endPoint.y > movePoint.y  && endPoint.y - beganPoint.y > 100 {
                closeView()
            }else{
                diplayPlayerView()
            }
        }
    }
    
    
    func diplayPlayerView(){
        NSLayoutConstraint.deactivate(hiddenConstraints)
        NSLayoutConstraint.activate(displayConstraints)
        let barHeight = self.superview!.safeAreaInsets.top
        playerViewTopAnchor.constant = barHeight+10
        UIViewPropertyAnimator.init(duration: 0.5, dampingRatio: 0.6) {
            self.superview?.layoutIfNeeded()
            }.startAnimation()
    }
    
    
    func hiddenPlayerView(){
        NSLayoutConstraint.deactivate(displayConstraints)
        NSLayoutConstraint.activate(hiddenConstraints)
        let height = UIScreen.main.bounds.height
        playerViewTopAnchor.constant = height-toolBarHeight
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.6) {
            self.superview?.layoutIfNeeded()
        }.startAnimation()
    }
    
    
}
