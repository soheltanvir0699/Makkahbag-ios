//
//  VideoPlayerController.swift
//  MakkahBag
//
//  Created by appleguru on 26/4/20.
//  Copyright © 2020 Apple Guru. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
//class VideoPlayerController: UIViewController,AVPlayerViewControllerDelegate {
//    @IBOutlet weak var videoView: UIView!
//    var urlLink = ""
//    var avPlayer: AVPlayer!
//    var avPlayerLayer: AVPlayerLayer!
//    var paused: Bool = false
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////       avPlayer = AVPlayer(url: videoURL!)
//         avPlayerLayer = AVPlayerLayer(player: avPlayer)
//         avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//          avPlayer.volume = 0
//         avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
//
//        avPlayerLayer.frame = CGRect(x: 10, y: self.view.center.y-100, width: self.view.frame.width - 20, height: 200)
//        self.view.backgroundColor = UIColor.clear;
//        //self.view.layer.insertSublayer(avPlayerLayer, at: 0)
//
//         NotificationCenter.default.addObserver(self,selector:#selector(playerItemDidReachEnd),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,object: avPlayer.currentItem)
//         avPlayer.seek(to: CMTime.zero)
//         avPlayer.play()
//         self.avPlayer.isMuted = true
        
   // }
//    override func viewDidAppear(_ animated: Bool) {
//        let videoURL = URL(string: "https://ttt.makkahbag.com/storage/system_uploads/1565679076.mp4")
//        playVideo(url: videoURL!)
//    }
//
//    @objc func playerItemDidReachEnd() {
//        avPlayer.seek(to: CMTime.zero)
//    }
////    func playVideo(url: URL) {
//        let player = AVPlayer(url: url)
//
//        let vc = AVPlayerViewController()
//        vc.player = player
//         vc.player?.play()
//        present(vc, animated: true, completion: nil)
//    }
//    @IBAction func backAction(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
//}
