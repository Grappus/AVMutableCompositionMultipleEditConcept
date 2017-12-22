//
//  PlayerItemFramesGenerator.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/11/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerItemFramesGeneratorDelegate:class {
    func framesArray(images_:Array<UIImage>)
}
class PlayerItemFramesGenerator: NSObject {
    
    fileprivate var current_images:Array<Any>?
    fileprivate var current_playerItem_url:URL? = nil
    weak var delegate:PlayerItemFramesGeneratorDelegate?
    
    init(_ url_:URL){
        super.init()
        current_playerItem_url = url_
        start_frame_generation()
    }
    
    fileprivate func start_frame_generation(){
        let asset_ = AVAsset.init(url: current_playerItem_url!)
        let image_generator = AVAssetImageGenerator.init(asset: asset_)
        image_generator.maximumSize = CGSize.init(width: 100, height: 50)
        let duration_ = asset_.duration
        var times_ = Array<Any>.init()
        let increment_ = duration_.value/10
        var current_value:CMTimeValue = 0
        //Type 'CMTimeValue' does not confirm to protocol 'Sequence'
        while current_value<=duration_.value {
            let time_ = CMTimeMake(current_value, duration_.timescale)
            times_.append(time_)
            current_value = current_value + increment_
        }
        
        let image_count = times_.count
        var images_ = Array<Any>.init()
        image_generator.requestedTimeToleranceAfter = kCMTimeZero
        image_generator.requestedTimeToleranceBefore = kCMTimeZero
        var counter = 0
        
        image_generator.generateCGImagesAsynchronously(forTimes: times_ as! [NSValue]) { [weak self](requestedTime:CMTime, image:CGImage?, actualTime:CMTime, result:AVAssetImageGeneratorResult,error:Error?) in
            
            if result == AVAssetImageGeneratorResult.succeeded{
                let image1 = UIImage.init(cgImage: image!)
                images_.append(image1)
                counter = counter+1
                
                if counter == image_count-1{
                    
                    print(images_)
                    self?.current_images = images_
                    //show these images on collection view
                    //acc to mvc,pass this array to your controller and that will show it on the view
                    DispatchQueue.main.async{
                    self?.delegate?.framesArray(images_: images_ as! Array<UIImage>)
                    }
                }
            }
        }
    }
    //write the above functionality for a player item as well
}
