//
//  VideoCacheManager.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import Foundation

protocol VideoCacheManager {
    associatedtype Cache
    associatedtype DownloadTask
    
    var cache: Cache { get }
    var downloadTasks: [URL: DownloadTask] { get }
    
    func getVideo(with url: URL, completion:  @escaping (Result<URL?, Error>) -> Void)
    func downloadVideo(with url: URL, completion: @escaping (Result<URL?, Error>) -> Void)
    func pauseDownload(for url: URL)
    func resumeDownload(for url: URL)
    func retryDownload(for url: URL)
    func clearCache()
}
