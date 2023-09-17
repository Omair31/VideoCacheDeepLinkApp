//
//  FileStoreManager.swift
//  SampleTestApp
//
//  Created by Omeir on 17/09/2023.
//

import Foundation

protocol FileStoreManager {
    func handleFileManagement(tempFileURL: URL, newFileURL: URL, completion: @escaping (Result<URL?, Error>) -> Void)
}
