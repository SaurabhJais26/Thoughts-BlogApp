//
//  DatabaseManager.swift
//  Thoughts
//
//  Created by Saurabh Jaiswal on 17/07/24.
//

import Foundation
import FirebaseFirestore

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    public func insertBlogPost(
        blogPost: BlogPost,
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
    }
    
    public func getAllPosts(
        completion: @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func getPosts(
        for user: User,
        completion: @escaping ([BlogPost]) -> Void
    ) {
        
    }
    
    public func insertUser(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }
}
