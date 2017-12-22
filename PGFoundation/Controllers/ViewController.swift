//
//  ViewController.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 12/3/16.
//  Copyright © 2016 Puneet Gurtoo. All rights reserved.
//
//

import UIKit
import AVFoundation
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PGPlayerCurrentItemDelegate,PlayerItemFramesGeneratorDelegate {

 
//MARK:outlets and other objects
    var playerLayer__:AVPlayerLayer?
    var currentSource_:NSString?
    var player_:PGPlayer?
    var collectionViewDataSource_:Array<UIImage> = []
    var frame_generator:PlayerItemFramesGenerator?
    var scrollingPoint:CGPoint?
    let total_scroll_width:Int = 10*100
    let transition = PGAnimator()
    var lastPlaybackRate:Float?
    @IBOutlet weak var playerLayer_: UIView!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var currentStatusLbl: UILabel!
    @IBOutlet weak var framesCollectionview: UICollectionView!
    @IBOutlet weak var slider_: UISlider!
    
//MARK:View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let bundle_ = Bundle.main
        let url_ = bundle_.url(forResource: "bunny", withExtension: "mp4")
        
        //let url_ = URL.init(string: "https://authdigicel.matrixstream.com/api/client/vodwatchcontentformat1.ashx?&provider=digicel&subscriber=2C9C38977176BC97E0538E9F10AC3F36&password=gUSf72kJj2thvVF9wwZL02KgnnBuXFvNo6mwBaQ6CrweCCkKKR3sG5FLaA8XgOp&parentalControlCode=&device=3&deviceID=636394198341150590&contentID=1784&time=59A2BB36&secure=73F48FCA5903C43DCDD0E930D6549D66&version=1")
        
        currentSource_ = url_?.absoluteString as NSString?
        
        scrollingPoint = CGPoint.init(x: 0, y: 0)
        
        //optional...do it for generating frames
        frame_generator = PlayerItemFramesGenerator.init(url_!)
        frame_generator?.delegate = self
        
        player_ = PGPlayer.player()
        player_!.delegate = self
        player_!.setItemWithUrl(url_!)
        playerLayer__ = AVPlayerLayer.init(player: player_)
        playerLayer__?.frame = playerLayer_.bounds
        playerLayer_.layer.addSublayer(playerLayer__!)

        player_!.play()
        
        //slider values
        slider_.maximumValue = Float(CMTimeGetSeconds((player_?.currentItem?.asset.duration)!))
        slider_.minimumValue = 0.0
        slider_.value = 0.0
    }
    
    override func viewDidLayoutSubviews(){
    }

    
//MARK:Convenience methods
    func resetStatusLbl(){
        currentStatusLbl.text = "--"
    }
    
    
//MARK:PGPlayerCurrentItemTime delegate methods
    func currentItemTime(_ time_: Float64) {
        //pass this time to UILabel
        let time_in_string = NSString(format: "%.2f",time_)
        currentTimeLbl.text = time_in_string as String
        slider_.value = Float(time_)
    }
    
    func currentItemStatus(_ status_:String){
        currentStatusLbl.text = status_
    }
    
    
//MARK:Action methods
    @IBAction func replaceItemBtn_Action(_ sender: AnyObject){
        resetStatusLbl()
        let bundle_ = Bundle.main
        let url_ = bundle_.url(forResource: "sample_mpeg4", withExtension: "mp4")
        currentSource_ = url_?.absoluteString as NSString?
        scrollingPoint = CGPoint.init(x: 0, y: 0)
        
        //optional...do it for generating frames
        frame_generator = PlayerItemFramesGenerator.init(url_!)
        frame_generator?.delegate = self
        
        player_!.setItemWithUrl(url_!)
        playerLayer__?.player = player_
        player_!.play()
    }
    
   
    @IBAction func speedAction(_ sender: Any) {
        //player_?.pause()
        let operationVC = storyboard?.instantiateViewController(withIdentifier: "OperationVC") as! OperationVC
        //operationVC.operationPlayer = player_
        operationVC.source_ = currentSource_! as String
        operationVC.current_time = player_?.currentTime()
        operationVC.transitioningDelegate = self
        present(operationVC, animated: true, completion: nil)
        player_?.pause()
    }
    
    @IBAction func trimAction(_ sender: Any) {
        resetStatusLbl()
        let startTime = kCMTimeZero
        let endTime = CMTimeMake(3, 1)
        let videoEditor = PGVideoEditingOperations.sharedEditor
        videoEditor.trimVideo((player_?.currentItem)!, fromTime: startTime, toTime: endTime, success: {[weak self]newPlayerItem in
            print("success")
            self?.player_?.setItem(newPlayerItem)
            self?.playerLayer__?.player = self?.player_
            self?.player_!.play()
        })
    }

    
//MARK:PlayerItemFramesGeneratorDelegate methods
    func framesArray(images_: Array<UIImage>) {
        
        //show this on collection view
        collectionViewDataSource_ = images_
        framesCollectionview.dataSource = self
        framesCollectionview.delegate = self
        framesCollectionview.reloadData()
    }


//MARK:PlayerItemFramesGeneratorDelegate methods
    func timerCallback(_ total_calls: String) {
    
        let val = Int(total_calls)
        let scroll_points = total_scroll_width/val!
        self.framesCollectionview.contentOffset = scrollingPoint!
        let x_ = Int(scrollingPoint!.x) + scroll_points
        scrollingPoint = CGPoint.init(x:x_ , y: 0)
    }
    
    
//MARK:CollectionView delegate and dataSourceMethods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewDataSource_.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FramesCollectionViewCell", for: indexPath) as! FramesCollectionViewCell
        let img = collectionViewDataSource_[indexPath.row]
        let ci_image = CIImage.init(image: img)
        cell.image_.image = UIImage.init(ciImage: ci_image!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 50)
    }
    

//MARK:Deinit method
    deinit{
        print("deinit VC")
    }
   
    //MARK:Slider delegate methods
    @IBAction func scrubbingDidStart(_ sender: Any) {
        print("start")
        lastPlaybackRate = player_?.rate
        player_?.pause()
        player_?.removeTimeObserver(player_?.timeObserver as Any)
        player_?.timeObserver = nil
    }
    
    @IBAction func scrubbedToTime(_ sender: Any) {
        print("\(slider_.value)")
        player_?.currentItem?.cancelPendingSeeks()
        //player_?.seek(to: CMTimeMakeWithSeconds(Float64(slider_.value), Int32(NSEC_PER_SEC)))
        player_?.seek(to: CMTimeMakeWithSeconds(Float64(slider_.value), Int32(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
    }
    
    @IBAction func scrubbingDidEnd(_ sender: Any) {
        print("end")
        player_?.addPlayerItemTimeObserver()
//        if lastPlaybackRate>0.0 {
//            player_?.play()
//        }
        player_?.play()
    }
}

//MARK:Extension
extension ViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}



