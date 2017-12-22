//
//  VideosCollectionVC.swift
//  PGFoundation
//
//  Created by Puneet Gurtoo on 1/6/17.
//  Copyright © 2017 Puneet Gurtoo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
private let reuseIdentifier = "VideosCollectionViewCell"

var urlArray:Array<URL?> = []

class VideosCollectionVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        let bundle_ = Bundle.main
        let url1 = bundle_.url(forResource: "bunny", withExtension: "mp4")
        let url2 = bundle_.url(forResource: "sample_mpeg4", withExtension: "mp4")
        
        // Register cell classes
      //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        urlArray = [url1,url2]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideosCollectionViewCell
        
        if indexPath.row%2 == 0 {
            let player_:AVPlayer = AVPlayer.init(url: urlArray[0]!)
            let playerLayer_ = AVPlayerLayer.init(player: player_)
            playerLayer_.frame = cell.playerView_.bounds
            cell.playerView_.layer.addSublayer(playerLayer_)
            player_.volume = 0.0
            player_.play()
        }
        else{
            let player_:AVPlayer = AVPlayer.init(url: urlArray[1]!)
            let playerLayer_ = AVPlayerLayer.init(player: player_)
            playerLayer_.frame = cell.playerView_.bounds
            cell.playerView_.layer.addSublayer(playerLayer_)
            player_.volume = 0.0
            player_.play()
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: view.frame.size.width/3, height: 150)
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
