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
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Fetch Video", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(fetchVideo), for: .touchUpInside)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .blue
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addFetchButton()
        addActivityIndicator()
    }
    
    fileprivate func addActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    fileprivate func addFetchButton() {
        view.addSubview(fetchButton)
        NSLayoutConstraint.activate([
            fetchButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            fetchButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            fetchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            fetchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func fetchVideo() {
        fetchButton.isEnabled = false
        activityIndicator.startAnimating()
        videoCacheManager.getVideo(with: URL(string: "https://www.pexels.com/download/video/18122212/?fps=29.97&h=640&w=360")!) { result in
            switch result {
            case .success(let fileURL):
                if let fileURL {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.fetchButton.isEnabled = true
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
