//
//  StorageManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage()
    
    private init() {}
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        guard let pngData = image?.pngData() else {
            return
        }
        storage.reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadUrlForProfilePicture(
        path: String,
        completion: @escaping (URL?) -> Void
    ) {
        storage.reference(withPath: path)
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    public func uploadBlogHeaderImage(
        email: String,
        image: UIImage,
        postId: String,
        completion: @escaping (Bool) -> Void
    ) {
        let path = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        guard let pngData = image.pngData() else {
            return
        }
        storage.reference(withPath: "post_headers/\(path)/\(postId).png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    public func downloadUrlForPostHeader(
        email: String,
        postId: String,
        completion: @escaping (URL?) -> Void
    ) {
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "_")
            .replacingOccurrences(of: ".", with: "_")
        
        storage.reference(withPath: "post_headers/\(emailComponent)/\(postId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
}

