//
//  StorageManger.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/11/2.
//

import Foundation
import FirebaseStorage

final class StorageManger {
    
    static let shared = StorageManger()
    
    private let storage = Storage.storage().reference()
    
    /*
     /images/hbxx-icloud-com_profile_picture.png
     */
    typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                print("failedToUpload images to FirebaseStorage")
                completion(.failure(StorageError.failedToUpload))
                return
            }
    
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failedToGetDownloadURL images from FirebaseStorage")
                    completion(.failure(StorageError.failedToGetDownloadURL))
                    return
                }
    
                let urlString = url.absoluteString
                print("profile images download url returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        }
    }
}
