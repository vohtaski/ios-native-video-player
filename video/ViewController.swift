//
//  ViewController.swift
//  video
//
//  Created by Evgeny on 20/1/16.
//  Copyright © 2016 vohtaski. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia

class ViewController: UIViewController {
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    
    var updater : CADisplayLink! = nil
    var duration: Double!
    
    @IBOutlet weak var totalTime: UILabel!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var progressBar: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: "https://s3.amazonaws.com/vids4project/sample.mp4")
        playerItem = AVPlayerItem(URL: url!)
        player = AVPlayer(playerItem: playerItem!)
        
        let playerLayer = AVPlayerLayer(player: player!)
        playerLayer.frame = CGRectMake(0, 0, 300, 200)
        self.view.layer.addSublayer(playerLayer)
        
        progressBar.minimumValue = 0
        progressBar.maximumValue = 100
        
        duration = CMTimeGetSeconds(playerItem!.asset.duration)
        totalTime.text = "\(round(duration*10)/10)s"
        currentTime.text = "0.0"
    }
    
    func trackAudio() {
        let curTime = CMTimeGetSeconds(playerItem!.currentTime())
        let normalizedTime = Float(curTime * 100.0 / duration)
        progressBar.value = normalizedTime
        currentTime.text = "\(round(curTime*10)/10)"
    }
    
    @IBAction func btnClicked(sender: UIButton) {
        if player?.rate == 0 {
            player!.play()
            sender.setTitle("Pause", forState: .Normal)
            
            updater = CADisplayLink(target: self, selector: Selector("trackAudio"))
            updater.frameInterval = 1
            updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)

        } else {
            player!.pause()
            updater.invalidate()
            sender.setTitle("Play", forState: .Normal)
        }
    }
    
    
    @IBAction func jumpTo30(sender: UIButton) {
        let point:Double = duration * 0.3
        let preferredTimeScale : Int32 = 30000
        let time = CMTimeMake(Int64(point*30000), preferredTimeScale)
        playerItem?.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        let normalizedTime = Float(CMTimeGetSeconds(time) * 100.0 / duration)
        progressBar.value = normalizedTime
        
        let curTime = CMTimeGetSeconds(playerItem!.currentTime())
        currentTime.text = "\(round(curTime*10)/10)"
    }
    
    @IBAction func jumpTo60(sender: UIButton) {
        let point:Double = duration * 0.6
        let preferredTimeScale : Int32 = 30000
        let time = CMTimeMake(Int64(point*30000), preferredTimeScale)
        playerItem?.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        let normalizedTime = Float(CMTimeGetSeconds(time) * 100.0 / duration)
        progressBar.value = normalizedTime
        
        let curTime = CMTimeGetSeconds(playerItem!.currentTime())
        currentTime.text = "\(round(curTime*10)/10)"
    }
    
    @IBAction func moveSlider(sender: UISlider) {
        let point:Double = Double(sender.value) / 100 * duration
        let preferredTimeScale : Int32 = 30000
        let time = CMTimeMake(Int64(point*30000), preferredTimeScale)

        playerItem?.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        
        let curTime = CMTimeGetSeconds(playerItem!.currentTime())
        currentTime.text = "\(round(curTime*10)/10)"
    }
    
}

