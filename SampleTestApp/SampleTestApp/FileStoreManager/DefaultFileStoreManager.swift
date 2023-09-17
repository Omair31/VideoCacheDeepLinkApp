//
//  DefaultFileStoreManager.swift
//  SampleTestApp
//
//  Created by Omeir on 17/09/2023.
//

import Foundation

class DefaultFileStoreManager: FileStoreManager {
    
    let fileManager: FileManager = .default
    
    func handleFileManagement(tempFileURL: URL, newFileURL: URL, completion: @escaping (Result<URL?, Error>) -> Void) {
        do {
            try fileManager.moveItem(at: tempFileURL, to: newFileURL)
            completion(.success(newFileURL))
        } catch {
            completion(.failure(error))
        }
    }
}
