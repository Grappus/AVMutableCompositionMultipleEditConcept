//
//  OperationVC.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/18/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//

import UIKit
import AVFoundation
class OperationVC: UIViewController,PlayerItemFramesGeneratorDelegate {

    var playerLayer__:AVPlayerLayer?
    var operationPlayer:PGPlayer?
    var source_:String? = nil
    var current_time:CMTime?
    @IBOutlet weak var playerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        operationPlayer = PGPlayer.player()
        operationPlayer?.setItemWithStringPath(source_!)
        playerLayer__ = AVPlayerLayer.init(player: operationPlayer)
        playerLayer__?.videoGravity = AVLayerVideoGravityResizeAspectFill
        operationPlayer?.seek(to: current_time!, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
       // operationPlayer?.play()
    }
  
    override func viewDidLayoutSubviews(){
        playerLayer__?.frame = playerView.bounds
        playerView.layer.addSublayer(playerLayer__!)
    }
    
//MARK:PlayerItemFramesGeneratorDelegate methods
    func framesArray(images_: Array<UIImage>) {
        
        //show this on collection view
//        collectionViewDataSource_ = images_
//        framesCollectionview.dataSource = self
//        framesCollectionview.delegate = self
//        framesCollectionview.reloadData()
    }
    
//MARK:Action methods

    @IBAction func doneAction(_ sender: Any) {
    }
    @IBAction func cancelAction(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func playAction(_ sender: Any) {
        operationPlayer?.play()
    }
}
