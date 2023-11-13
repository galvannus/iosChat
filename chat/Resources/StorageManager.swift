//
//  StorageManager.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 09/11/23.
//

import FirebaseStorage
import Foundation

final class StorageManager {
    static let shared = StorageManager()

    private let storage = Storage.storage().reference()

    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void

    // Uploads picture to firebase storage and returns completion with url string to download
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { _, error in
            guard error == nil else {
                // failed
                print("Failed to upload data to firebase for picture.")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }

            self.storage.child("images/\(fileName)").downloadURL(completion: { url, _ in
                guard let url = url else {
                    print("Failed to download url.")
                    completion(.failure(StorageErrors.failedTogetDownloadUrl))
                    return
                }

                let urlString = url.absoluteString
                print("Download url returned: \(urlString)")
                completion(.success(urlString))
            })
        })
    }

    public enum StorageErrors: Error {
        case failedToUpload
        case failedTogetDownloadUrl
    }

    // Download url from Firebase
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child("\(path)")

        reference.downloadURL(completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedTogetDownloadUrl))
                return
            }

            completion(.success(url))
        })
    }
}
