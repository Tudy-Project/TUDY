//
//  CommonFirebaseProjectData.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/13.
//

import Foundation
import Firebase
import FirebaseFirestore

struct CommonFirebaseProjectData {
    
    private var documentListener: ListenerRegistration?
    
    static func saveProjectData(_ project: Project, completion: ((Error?) -> Void)? = nil) {
        
        var project = project
        let db = Firestore.firestore()
        let projectRef = db.collection("PROJECT").document()
        
        project.writeDate = Date().description
        
        guard let dictionary = project.asDictionary else {
            print("[DEBUG] 프로젝트 Firebase 디버그 오류")
            return
        }
        projectRef.setData(dictionary) { error in
            if let error = error {
                print("파이어베이스 저장 에러 \(error.localizedDescription)")
            }
        }
    }
    
    static func fetchProject(completion: @escaping([Project]) -> Void) {
        var projects: [Project] = []
        Firestore.firestore().collection("PROJECT").getDocuments { snapshot, error in
            if let error = error {
                print("[DEBUG] 프로젝트 정보 가져오기 실패 \(error.localizedDescription)")
                return
            }
            snapshot?.documents.forEach({ document in
                let dict = document.data()
                let project = Project(dict: dict)
                projects.append(project)
            })
            completion(projects)
        }
    }
}
