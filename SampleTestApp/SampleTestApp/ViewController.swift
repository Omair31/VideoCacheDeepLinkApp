//
//  ViewController.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    private lazy var cacheDirectoryName = "video-" + UUID().uuidString + ".mp4"
    
    private lazy var videoCacheManager: any VideoCacheManager = {
       let diskPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(cacheDirectoryName).path
       let memoryCapacity = 20 * 1024 * 1024
       let diskCapacity = 100 * 1024 * 1024
       return URLSessionVideoCacheManager(
            cache: URLCache(memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity, diskPath: diskPath),
            cacheDirectoryName: cacheDirectoryName,
            fileStoreManager: DefaultFileStoreManager()
       )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        videoCacheManager.getVideo(with: URL(string: "https://www.pexels.com/download/video/7565438/?fps=25.0&h=640&w=360")!) { result in
            switch result {
            case .success(let fileURL):
                if let fileURL {
                    DispatchQueue.main.async {
                        let playerVC = AVPlayerViewController()
                        playerVC.player = AVPlayer(url: fileURL)
                        self.present(playerVC, animated: true)
                        playerVC.player?.play()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        // Do any additional setup after loading the view.
    }
    
}
