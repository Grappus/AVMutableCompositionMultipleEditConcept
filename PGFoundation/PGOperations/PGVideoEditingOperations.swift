//
//  PGVideoEditingOperations.swift
//  PGFoundation
//
//  Created by sismac009 on 16/12/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit
import AVFoundation

class PGVideoEditingOperations: NSObject {
    
    static let sharedEditor = PGVideoEditingOperations()
    
    deinit {
        print("in operations deinit")
    }
/**
Trims the duration of playerItem passed and returns a new playerItem.     
*/
    func trimVideo(_ playerItem_:AVPlayerItem, fromTime:CMTime,toTime:CMTime,success:(_ newPlayerItem:AVPlayerItem)->Void){

        let trimTimeRange = CMTimeRangeMake(fromTime, toTime)
        let mutableComposition_ = AVMutableComposition.init()
        let compositionTrack = mutableComposition_.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
    //video
        let videoAssetTrack_ = playerItem_.asset.tracks(withMediaType: AVMediaTypeVideo).first
        do{
            try compositionTrack.insertTimeRange(trimTimeRange, of: videoAssetTrack_!, at: kCMTimeZero)
        }
        catch{
            print("video exception")
        }
    //audio
        let audioAssetTrack_ = playerItem_.asset.tracks(withMediaType: AVMediaTypeAudio).first
        if (audioAssetTrack_ != nil) {
            let audioTrack = mutableComposition_.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do{
                try audioTrack.insertTimeRange(trimTimeRange, of: audioAssetTrack_!, at: kCMTimeZero)
            }
            catch{
                print("audio exception")
            }
        }
        
        let item_ = AVPlayerItem.init(asset: mutableComposition_)
        print(CMTimeGetSeconds(item_.duration))
        success(item_)
    }
    
    func changeSpeed(_ playerItem_:AVPlayerItem, success:(_ newPlayerItem:AVPlayerItem)->Void){
    }
}




