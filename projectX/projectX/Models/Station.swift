//
//  Station.swift
//  projectX
//
//  Created by Radomyr Bezghin on 9/10/20.
//  Copyright © 2020 Radomyr Bezghin. All rights reserved.
//

import FirebaseFirestore

struct Station{
    /// A unique ID identifying the station, generated by Firestore.
    var documentID: String

    /// brief description of the station.
    var info: String

    /// The name of the station.
    var stationName: String

    /// The number of followers of the station.
    var followers: Int

    /// The date when station was created.
    var date: Date
    
    /// Station photo url stored in the Firestore
    var imageURL: URL?
}
extension Station{
    /// Initializes a restaurant from a documentID and some data, ostensibly from Firestore.
    private init?(documentID: String, dictionary: [String: Any]) {
      guard let info = dictionary["info"] as? String,
          let stationName = dictionary["stationName"] as? String,
          let followers = dictionary["followers"] as? Int,
          let timestamp = dictionary["date"] as? Timestamp,
          let imageURLString = dictionary["imageURL"] as? String else { return nil }

      guard let imageURL = URL(string: imageURLString) else { return nil }

        self.init(documentID: documentID,
                  info: info,
                  stationName: stationName,
                  followers: followers,
                  date: timestamp.dateValue(),
                  imageURL: imageURL)
    }

    init?(document: QueryDocumentSnapshot) {
      self.init(documentID: document.documentID, dictionary: document.data())
    }
    init?(document: DocumentSnapshot) {
      guard let data = document.data() else { return nil }
      self.init(documentID: document.documentID, dictionary: data)
    }
  
    init(info: String,
                stationName: String,
                followers: Int,
                date: Date,
                imageURL: URL?) {
        let document = Firestore.firestore().stations.document() // returns a brand new document
        documentID = document.documentID
        self.info = info
        self.stationName = stationName
        self.followers = followers
        self.date = date
        self.imageURL = imageURL
    }
    /// used to generate json like format for db
    var documentData: [String: Any] {
      return [
        "info": info,
        "stationName": stationName,
        "followers": followers,
        "date": Timestamp(date:date),
        "imageURL": imageURL
      ]
    }
}