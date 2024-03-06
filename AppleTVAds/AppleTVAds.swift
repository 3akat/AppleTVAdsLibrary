//
//  AppleTVAds.swift
//  
//
//  Created by alex on 27.12.23.
//
import UIKit
import GoogleInteractiveMediaAds
import AVFoundation


@objc(AppleTVAds)
open class AppleTVAds: NSObject{
    
    @objc(openSDK)
    public func openSDK(){
        let window =  UIWindow(frame: UIScreen.main.bounds);
        let rootNavigationController = UINavigationController();
        let initialViewControlleripad : UIViewController = TVAdsViewController();
        window.rootViewController?.present(initialViewControlleripad, animated: false);
    }
    
    open func getValue() -> String

    {
        return "Value came from AppleTVAds.swift!";
    }
    
}
