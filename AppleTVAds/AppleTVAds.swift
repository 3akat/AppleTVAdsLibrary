//
//  AppleTVAds.swift
//  
//
//  Created by alex on 27.12.23.
//
import UIKit
import GoogleInteractiveMediaAds
import AVFoundation

open class TVAdsViewController: UIViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate{
    
  static let ContentURLString = "https://storage.googleapis.com/interactive-media-ads/media/stock.mp4"
//  static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_ad_samples&sz=640x480&cust_params=sample_ct%3Dlinear&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="
    
    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?iu=/21775744923/external/single_preroll_skippable&sz=640x480&ciu_szs=300x250%2C728x90&gdfp_req=1&output=vast&unviewed_position_start=1&env=vp&impl=s&correlator="

    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!

    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var playerViewController: AVPlayerViewController!
    
    var player: AVPlayer!
    enum VideoStatus {
        case playing
        case paused
        case complete
    }
    var videoStatus: VideoStatus = VideoStatus.playing

    deinit {
      NotificationCenter.default.removeObserver(self)
    }

    public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.black;
    setUpContentPlayer()
//    setUpAdsLoader()
      
  }
    
    public override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated);
//        requestAds()
    }
    
    func setUpAdsLoader() {
      adsLoader = IMAAdsLoader(settings: nil)
      adsLoader.delegate = self
      requestAds()
    }

    func requestAds() {
      // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: self.view, viewController: self)
        adDisplayContainer.adContainer.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        adDisplayContainer.adContainer.addGestureRecognizer(tap)
      // Create an ad request with your ad tag, display container, and optional user context.
      let request = IMAAdsRequest(
          adTagUrl: TVAdsViewController.AdTagURLString,
          adDisplayContainer: adDisplayContainer,
          contentPlayhead: contentPlayhead,
          userContext: nil)

      adsLoader.requestAds(with: request)
    }


    func setUpContentPlayer() {
      // Load AVPlayer with path to your content.
      let contentURL = URL(string: TVAdsViewController.ContentURLString)!
      player = AVPlayer(url: contentURL)
      player.addObserver(self, forKeyPath: "timeControlStatus", options: NSKeyValueObservingOptions.new, context: nil)

      playerViewController = AVPlayerViewController()
      playerViewController.player = player

      // Set up your content playhead and contentComplete callback.
      contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(TVAdsViewController.contentDidFinishPlaying(_:)),
        name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
        object: player.currentItem);

      showContentPlayer()
    }

  func showContentPlayer() {
    self.addChild(playerViewController)
    playerViewController.view.frame = self.view.bounds
    self.view.insertSubview(playerViewController.view, at: 0)
    playerViewController.didMove(toParent:self)
  }

  func hideContentPlayer() {
    // The whole controller needs to be detached so that it doesn't capture  events from the remote.
    playerViewController.willMove(toParent:nil)
    playerViewController.view.removeFromSuperview()
    playerViewController.removeFromParent()
  }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        adsLoader.contentComplete()
        adsManager.destroy()
        videoStatus = VideoStatus.complete
     }
    
    public func adsLoader(_ loader: IMAAdsLoader, adsLoadedWith adsLoadedData: IMAAdsLoadedData) {
      adsManager = adsLoadedData.adsManager
      adsManager.delegate = self
      adsManager.initialize(with: nil)
    }

    public func adsLoader(_ loader: IMAAdsLoader, failedWith adErrorData: IMAAdLoadingErrorData) {
        print("Error loading ads: " + (adErrorData.adError.message ?? ""))
        //todo
      showContentPlayer()
//      playerViewController.player?.play()
    }
    
    public func adsManager(_ adsManager: IMAAdsManager, didReceive event: IMAAdEvent) {
        print("AAAAAAAAAAEvent")
        print(event.typeString)
      // Play each ad once it has been loaded
      if event.type == IMAAdEventType.LOADED {
        adsManager.start()
      } else if event.type == IMAAdEventType.ALL_ADS_COMPLETED {
          adsLoader.contentComplete()
          adsManager.destroy()
          videoStatus = VideoStatus.complete
      } else if event.type == IMAAdEventType.TAPPED {
          adsLoader.contentComplete()
          adsManager.destroy()
          videoStatus = VideoStatus.complete
      } else if event.type == IMAAdEventType.CLICKED {
            adsLoader.contentComplete()
            adsManager.destroy()
            videoStatus = VideoStatus.complete
        }
    }
    
    public func adsManager(_ adsManager: IMAAdsManager, didReceive error: IMAAdError) {
      // Fall back to playing content
        print("AdsManager error: " + (error.message ?? ""))
      showContentPlayer()
      playerViewController.player?.play()
    }
    
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
      // Pause the content for the SDK to play ads.
      playerViewController.player?.pause()
      hideContentPlayer()
    }

    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
      // Resume the content since the SDK is done playing ads (at least for now).
      showContentPlayer()
        //todo
//      playerViewController.player?.play()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
      if keyPath == "timeControlStatus" {
          if self.player.timeControlStatus == .paused
                && videoStatus != VideoStatus.paused
          {
              print("video paused")
              setUpAdsLoader()
              videoStatus = VideoStatus.paused
          } else if self.player.timeControlStatus == .playing
          {
              print("video playing")
              videoStatus = VideoStatus.playing
          }
      }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        print("video CLICKED")
        if( videoStatus != VideoStatus.complete){
            adsLoader.contentComplete()
            adsManager.destroy()
            videoStatus = VideoStatus.complete
            showContentPlayer()
        }
    }
    
}
