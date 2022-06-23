//
//  FirebaseStorage.swift
//  TUDY
//
//  Created by neuli on 2022/06/18.
//

import Foundation

import FirebaseStorage

struct FirebaseStorage {
    
    /// 이미지 저장 함수 (FireStorage)
    /// 이미지 전달 시 completion handler로 저장된 이미지 URL을 전달해줍니다.
    static func saveImage(image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { meta, error in
            if let error = error {
                print("[DEBUG] 이미지 저장 실패 \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { url, error in
                if let error = error {
                    print("[DEBUG] 이미지 url 다운로드 실패 \(error.localizedDescription)")
                }
                guard let imageURL = url?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
