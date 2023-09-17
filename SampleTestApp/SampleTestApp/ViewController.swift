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
        let button = UIButton(frame: CGRect(x: 40, y: 40, width: 100, height: 100))
        button.setTitle("Fetch Video", for: .normal)
        view.addSubview(button)
        button.backgroundColor = .yellow
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(fetchVideo), for: .touchUpInside)
    }
    
    @objc func fetchVideo() {
        videoCacheManager.getVideo(with: URL(string: "https://www.pexels.com/download/video/7565438/")!) { result in
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
    }
    
}
