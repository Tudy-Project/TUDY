//
//  CommonFirebaseProjectData.swift
//  TUDY
//
//  Created by Hojin Jang on 2022/06/13.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseProject {
    
    private var documentListener: ListenerRegistration?
    
    static func saveProjectData(_ project: Project, completion: ((Error?) -> Void)? = nil) {
        
        var project = project
        let db = Firestore.firestore()
        let projectRef = db.collection("PROJECT").document(project.projectId)
        
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
        Firestore.firestore()
            .collection("PROJECT")
            .order(by: "writeDate", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("[DEBUG] 프로젝트 정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                projects = []
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let project = Project(dict: dict)
                    projects.append(project)
                })
                completion(projects)
            }
    }
    
    static func fetchProjectByProjectID(projectID: String, completion: @escaping(Project) -> Void) {
        Firestore.firestore()
            .collection("PROJECT")
            .whereField("projectId", isEqualTo: projectID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("[DEBUG] 프로젝트 정보 가져오기 실패 \(error.localizedDescription)")
                    return
                }
                snapshot?.documents.forEach({ document in
                    let dict = document.data()
                    let project = Project(dict: dict)
                    completion(project)
                })
            }
    }
    
    static func updateProjectHeart(_ project: Project, completion: @escaping(Int) -> Void) {
        let projectID = project.projectId
        
        fetchProjectByProjectID(projectID: projectID) { project in
            let favoriteCount = Int(project.favoriteCount)
            Firestore.firestore()
                .collection("PROJECT")
                .document(projectID)
                .updateData(["favoriteCount" : (favoriteCount + 1)])
            completion(favoriteCount + 1)
        }
    }
    
    static func updateIsRecruit(_ project: Project, completion: @escaping() -> Void) {
        let projectID = project.projectId
        let changedIsRecruit = project.isRecruit ? false : true
        Firestore.firestore()
            .collection("PROJECT")
            .document(projectID)
            .updateData(["isRecruit" : changedIsRecruit])
        completion()
    }
}
