//
//  DataManager.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/6/24.
//

import Foundation
import Firebase

@MainActor
class DataManager: ObservableObject{
    @Published var user = User()
    @Published var isLoggedIn = false
    
    var hasHitRoutineLimit: Bool {
        return user.routines.count == 5
    }

    func addRoutine(routine: Routine) {
        user.routines.append(routine)

    }
    
    func deleteRoutine(at offsets: IndexSet){
        user.routines.remove(atOffsets: offsets)
    }
    
//    func saveDogs() {
////        let object: [String: Any] = [
////            "name" : "Pitty" as NSObject,
////            "breed" : "Pitbull"
////            
////        
////        ]
////        database.child("Dogs" + UUID().uuidString).setValue(object)
//        let db = Firestore.firestore()
//        let ref =  db.collection("Dogs").document("Doodle")
//        ref.setData(["name": "pitty", "id" : 13]){ error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//        fetchDogs()
//    }
    
//    func fetchDogs() {
//        dogs.removeAll()
//        let db = Firestore.firestore()
//        let ref =  db.collection("Dogs")
//        ref.getDocuments { snapshot, error in
//            guard error == nil else {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            if let snapshot = snapshot {
//                for document in snapshot.documents {
//                    let data = document.data()
//                    
//                    let id =  data["id"] as? String ?? ""
//                    let name = data["name"] as? String ?? ""
//                    
//                    let dog = Dog(id: id, name: name)
//                    self.dogs.append(dog)
//                }
//            }
//        }
//    }
}
