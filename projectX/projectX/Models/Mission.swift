//
//  Board.swift
//  projectX
//
//  Created by Radomyr Bezghin on 10/16/20.
//  Copyright © 2020 Radomyr Bezghin. All rights reserved.
//

///Bulletin Board

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Mission:Identifiable, Codable{
    /// property wrapper that stores id of the document associated with data
    @DocumentID var id: String?

    /// station where post is posted.
    var stationID: String

    /// The name of the station.
    var stationName: String

    /// The number of likes of the post.
    var likes: Int

    /// User information duplicated in the post object.
    var userInfo: User

    /// The title of the post.
    var title: String
    
    /// The body text of the post.
    var text: String

    /// The date the review was posted.
    var date: Date
    
    /// Post photo url stored in the Firestore
    var imageURL: URL?
}
extension Mission{
    /// returns a new post object
    public init(stationID: String,
                stationName: String,
                likes: Int,
                userInfo: User,
                title: String,
                text: String,
                date: Date,
                imageURL: URL?) {
        self.stationID = stationID
        self.stationName = stationName
        self.likes = likes
        self.userInfo = userInfo
        self.title = title
        self.text = text
        self.date = date
        self.imageURL = imageURL
    }
}
