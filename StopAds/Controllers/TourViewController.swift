//
//  TourViewController.swift
//  StopAds
//
//  Created by Xiaohu on 10/6/15.
//  Copyright © 2015 Luokey. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class TourViewController: UIViewController {
    
    @IBOutlet weak var tourScrollView: UIScrollView!;
    @IBOutlet weak var firstView: UIView!;
    @IBOutlet weak var firstInfoLabel: UILabel!;
    @IBOutlet weak var logoImageView: UIImageView!;
    @IBOutlet weak var secondView: UIView!;
    @IBOutlet weak var secondInfoLabel: UILabel!;
    @IBOutlet weak var thirdView: UIView!;
    @IBOutlet weak var thirdInfoLabel: UILabel!;
    @IBOutlet weak var fourthView: UIView!;
    @IBOutlet weak var fourthInfoLabel: UILabel!;
    @IBOutlet weak var startButton: UIButton!;
    @IBOutlet weak var pageControl: UIPageControl!;
    
    @IBOutlet weak var firstMovieView: UIView!;
    @IBOutlet weak var secondMovieView: UIView!;
    
    var firstMoviePlayer: AVPlayer?
    var secondMoviePlayer: AVPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.logoImageView.layer.cornerRadius = 40
        self.logoImageView.layer.masksToBounds = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let screenFrame = UIScreen.mainScreen().bounds
        self.tourScrollView.contentSize = CGSizeMake(screenFrame.size.width * 4, screenFrame.size.height)
        
        self.playFirstMovie()
        self.playSecondMovie()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "firstPlayerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.firstMoviePlayer!.currentItem)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "secondPlayerItemDidReachEnd:", name: AVPlayerItemDidPlayToEndTimeNotification, object: self.secondMoviePlayer!.currentItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Main methods
    
    @IBAction func tapStartButton(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func playFirstMovie() {
        
        if (self.firstMoviePlayer == nil) {
            
            let movieURL: NSURL = NSBundle.mainBundle().URLForResource("enable-app", withExtension: "mov")!
            self.firstMoviePlayer = AVPlayer(URL: movieURL)
            self.firstMoviePlayer!.seekToTime(CMTimeMake(1, 10))
            
            let playerLayer = AVPlayerLayer(player: self.firstMoviePlayer)
            playerLayer.frame = self.firstMovieView.bounds
            self.firstMovieView.layer.addSublayer(playerLayer)
        }
        else {
            self.firstMoviePlayer!.seekToTime(CMTimeMake(1, 10))
            self.firstMoviePlayer!.play()
        }
    }
    
    func playSecondMovie() {
        
        if (self.secondMoviePlayer == nil) {
            
            let movieURL: NSURL = NSBundle.mainBundle().URLForResource("action-sheet", withExtension: "mov")!
            self.secondMoviePlayer = AVPlayer(URL: movieURL)
            self.secondMoviePlayer!.seekToTime(CMTimeMake(1, 10))
            
            let playerLayer = AVPlayerLayer(player: self.secondMoviePlayer)
            playerLayer.frame = self.secondMovieView.bounds
            self.secondMovieView.layer.addSublayer(playerLayer)
        }
        else {
            self.secondMoviePlayer!.seekToTime(CMTimeMake(1, 10))
            self.secondMoviePlayer!.play()
        }
    }
    
    func firstPlayerItemDidReachEnd(notification: NSNotification) {
//        self.firstMoviePlayer!.seekToTime(kCMTimeZero)
        self.firstMoviePlayer!.seekToTime(CMTimeMake(1, 10))
        self.firstMoviePlayer!.play()
    }
    
    func secondPlayerItemDidReachEnd(notification: NSNotification) {
//        self.secondMoviePlayer!.seekToTime(kCMTimeZero)
        self.secondMoviePlayer!.seekToTime(CMTimeMake(1, 10))
        self.secondMoviePlayer!.play()
    }
    
    // MARK: - UIScrollView delegate
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset;
        self.pageControl.currentPage = (Int)(contentOffset.x / UIScreen.mainScreen().bounds.size.width)
        
        if (self.pageControl.currentPage == 1) {
            if (self.firstMoviePlayer?.currentTime() <= CMTimeMake(1, 10)) {
                self.playFirstMovie()
            }
        }
        else if (self.pageControl.currentPage == 2) {
            if (self.secondMoviePlayer?.currentTime() <= CMTimeMake(1, 10)) {
                self.playSecondMovie()
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
}
