//
//  PGPlayer.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/3/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Current player item delegate
 */
@objc protocol PGPlayerCurrentItemDelegate:class{
    func currentItemTime(_ time_:Float64)
    func currentItemStatus(_ status_:String)
    @objc optional func timerCallback(_ total_calls:String)
}

class PGPlayer: AVPlayer {
    //Singleton in swift
    //static let sharedPlayer = PGPlayer()
    var timeObserver:Any?;
    var lastItem:AVPlayerItem?
    var framesTimer:Timer?
    
    weak var delegate:PGPlayerCurrentItemDelegate?
    
    override init(){
        print("in player init")
        super.init()
        addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.new, context:nil)
    }
    
    deinit{
        print("in player deinit")
        
        self.removeTimeObserver(timeObserver as Any)
        removeObserver(self, forKeyPath: "currentItem")
        removeObserversForLastItem()
    }
    
    
   /**
   Sets the player Item.  
    */
    func setItem(_ playerItem_:AVPlayerItem){
        replaceCurrentItem(with: playerItem_)
    }
    
    /**
     Sets the player Item using url
     */
    func setItemWithUrl(_ url_:URL){
        setItem(AVPlayerItem.init(url: url_))
    }
    
    /**
     Sets the player Item using asset
     */
    func setItemWithAsset(_ asset_:AVAsset){
        setItem(AVPlayerItem.init(asset: asset_))
    }

    /**
     Sets the player Item using string.
     */
    func setItemWithStringPath(_ path_:String){
        setItemWithUrl(URL.init(string: path_)!)
    }
    
    /**
     Convenience method that returns a new instance of PGPlayer.
     */
    class func player() -> PGPlayer{
        return PGPlayer.init()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "currentItem"{
            initStatusObserver()
        }
            
        else if keyPath! == "status" {
            if currentItem?.status == AVPlayerItemStatus.readyToPlay{
                addPlayerItemTimeObserver()
                addPlayerItemEndObserver()
                //moveFrames()
            }
        }
    }
    
    fileprivate func initStatusObserver(){
        removeObserversForLastItem()
        lastItem = currentItem
        currentItem!.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    fileprivate func removeObserversForLastItem(){
        if let old = lastItem{
            print("player item deinit...observers removed")
            old.removeObserver(self, forKeyPath: "status")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: old)
        }
        lastItem = nil
    }
    
    fileprivate func addPlayerItemEndObserver(){
        print("player item init...item end observer added")
        let itemEndObserver = NSNotification.Name.AVPlayerItemDidPlayToEndTime
        NotificationCenter.default.addObserver(self, selector: #selector(PGPlayer.itemDidEnd), name: itemEndObserver, object: currentItem)
    }
    
    func itemDidEnd(){
        print("End")
        self.seek(to: kCMTimeZero)
        self.delegate?.currentItemStatus("End")
        //framesTimer?.invalidate()
    }
    
    func addPlayerItemTimeObserver(){
        print("player item init...time observer added")
        let interval:CMTime = CMTimeMakeWithSeconds(0.1 ,Int32(NSEC_PER_SEC));

        timeObserver = addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self](time:CMTime) in
            print("Time Observer Added")
            let currentTime = CMTimeGetSeconds(time)
            //call delegate method to pass this time to controller so that it can update view
            self?.delegate?.currentItemTime(currentTime)
        } as Any?
    }
    
    fileprivate func moveFrames(){
       framesTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
    }
    
    func timerCall(){
     
        let video_duration = currentItem?.duration
        let time_:Int = Int(CMTimeGetSeconds(video_duration!))

        let total_timer_calls = time_*10
        let str = String.init(format: "%d",total_timer_calls)
        self.delegate?.timerCallback!(str)
    }
}
