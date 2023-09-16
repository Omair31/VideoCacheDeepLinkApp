//
//  URLSessionVideoCacheManager.swift
//  SampleTestApp
//
//  Created by Omeir on 16/09/2023.
//

import Foundation

class URLSessionVideoCacheManager: VideoCacheManager {
    typealias Cache = URLCache
    
    typealias DownloadTask = URLSessionDownloadTask
    
    private let cacheDirectory: URL
    let cache: Cache
    var downloadTasks = [URL: DownloadTask]()

    init(cache: Cache, cacheDirectoryName: String) {
        cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(cacheDirectoryName)
        //self.cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: cacheDirectory.path)
        self.cache = cache
    }

    // Fetch a video from cache or download it if not cached
    func getVideo(with url: URL, completion: @escaping (Result<URL?, Error>) -> Void) {
        if let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)) {
            // Video is in cache
            completion(.success(cachedResponse.response.url))
        } else {
            // Video not in cache, download and cache it
            downloadVideo(with: url, completion: completion)
        }
    }

    // Download and cache a video
    func downloadVideo(with url: URL, completion: @escaping (Result<URL?, Error>) -> Void) {
        if downloadTasks[url] != nil {
            // A download task is already in progress for this URL
            return
        }

        let downloadTask = URLSession.shared.downloadTask(with: url) { (tempFileURL, response, error) in
            defer {
                self.downloadTasks[url] = nil
            }

            if let error = error {
                completion(.failure(error))
                return
            }

            if let tempFileURL = tempFileURL {
                // Save the video data to cache
                do {
                    let data = try Data(contentsOf: tempFileURL)
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                    self.cache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
                } catch let error {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
                // Create a unique file name for the cached video
                let fileName = UUID().uuidString
                let fileURL = self.cacheDirectory.appendingPathComponent(fileName)

                do {
                    try FileManager.default.moveItem(at: tempFileURL, to: fileURL)
                    completion(.success(fileURL))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(FileError.notFound))
            }
        }
        downloadTasks[url] = downloadTask
        downloadTask.resume()
    }

    // Pause a download task
    func pauseDownload(for url: URL) {
        if let downloadTask = downloadTasks[url] {
            downloadTask.suspend()
        }
    }

    // Resume a paused download task
    func resumeDownload(for url: URL) {
        if let downloadTask = downloadTasks[url] {
            downloadTask.resume()
        } else {
            // If the download task does not exist, start a new download
            getVideo(with: url) { _ in }
        }
    }

    // Retry a failed download task
    func retryDownload(for url: URL) {
        if let downloadTask = downloadTasks[url] {
            downloadTask.cancel()
            downloadTasks[url] = nil
        }
        getVideo(with: url) { _ in }
    }

    // Remove all cached videos
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        try? FileManager.default.removeItem(at: cacheDirectory)
    }
}
