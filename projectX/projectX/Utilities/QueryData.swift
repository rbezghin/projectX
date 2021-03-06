//
//  RealDATA.swift
//  projectX
//
//  Created by Jake Nations on 10/10/20.
//  Copyright © 2020 Radomyr Bezghin. All rights reserved.
//
import FirebaseFirestore

/*
 Notes for later on:
    1. Need to add more try&catch to each query to prevent crash, or loss of service
        (I think I attempted this)
    2. Calculate the use case of average read and write for each user
    3.
 */




class QueryData {
    
    //Firestore related items
    private var query: Query!
    private var lastDocument: DocumentSnapshot!
    private var db: Firestore!
    
    //pagination
    var isPaginating = false
    var loaded = false
    
    func queryPost(pagination: Bool = false, completion: @escaping (Result<[Post], Error>) -> Void){
        
        if pagination {
            isPaginating = true
        }
        
         var posts = [Post]()
         db = Firestore.firestore()

        
        if pagination == false{
            query = db.collection("posts").limit(to: 5)
            
        }else{
            //This does not obtain ALL posts, it only grabs a few of the remaning items
            //Idea: use some fuckin math to batch write a odd number of posts, so that the remainder of the enire database is one, being the last document in the database
            if lastDocument != nil {
                query = db.collection("posts").start(afterDocument: lastDocument).limit(to: 5)
                query.addSnapshotListener { (snapshot, error) in
                    guard snapshot != nil else {
                    print("Error retreving data in query: \(error.debugDescription)")
                    return
                }
                }
            }else{
                return
            }
                
        }
        
        self.query.getDocuments { (snapshot, error) in
          if let snapshotDocuments = snapshot?.documents {
              for document in snapshotDocuments{
                  do{
                      if let post = try document.data(as: Post.self){
                          //print(post.userInfo.name)
                          posts.append(post)
                      }
                  } catch let error as NSError{
                      print("error: \(error.localizedDescription)")
                  }
              }
            self.lastDocument = snapshot!.documents.last
          }
            completion(.success(posts))
            
            if pagination {
                self.isPaginating = false
            }
        }

          
    }//function end
    //ADDED firstPass variable: A temporary fix to prevent runtime error of viewed channels
    func queryStations(firstPass: Bool = true,completion: @escaping (Result<[Station], Error>) -> Void){
        
        if firstPass {
            loaded = true
            var stations = [Station]()
            db = Firestore.firestore()
            
            db.collection("stations").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        do{
                            if let station = try document.data(as: Station.self){
                                //print(station.stationName)
                                stations.append(station)
                            }
                        } catch let error as NSError{
                            print("error: \(error.localizedDescription)")
                        }
                    }
                    
                }
                completion(.success(stations))
            }
        } else {
            
        }
        
    }//function end
}//class end


//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let position = scrollView.contentOffset.y
//        if position > (collectionView.contentSize.height-100-scrollView.frame.size.height){
//            guard !queryPosts.isPaginating else{
//                //we fetching data
//                return
//            }
//            queryPosts.queryPost(pagination: true) { result in
//                switch result {
//                    case .success(let moreData):
//                        self.postData.append(contentsOf: moreData)
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                    case .failure(_):
//                        break
//                }
//
//            }
//        }
//    }
