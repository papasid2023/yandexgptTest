////
////  ConnectToAI.swift
////  aitest
////
////  Created by Руслан Сидоренко on 27.05.2024.
////
//
//import UIKit
//
//class ConnectToAI {
//    
//    static let shared = ConnectToAI()
//    
//    public var iamToken: String = ""
//    
//    public var cloud_id: String = ""
//    
//    //MARK: GET IAM TOKEN
//    public func getIamToken(){
//        let myOauthToken = "y0_AgAAAAAFSi2nAATuwQAAAAEF2dcLAAD6qDJONxpCCpQ9VXtCqRQCSojrcg"
//        
//        let url = URL(string: "https://iam.api.cloud.yandex.net/iam/v1/tokens")
//        var request = URLRequest(url: url!, timeoutInterval: Double.infinity)
//        request.httpMethod = "POST"
//        request.setValue("b1gcevc330bgql34jbah", forHTTPHeaderField: "cloud_id")
//        let body = ["yandexPassportOauthToken": myOauthToken]
//        let bodyData = try? JSONSerialization.data(
//            withJSONObject: body,
//            options: []
//        )
//        request.httpBody = bodyData
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil, data != nil, response != nil else {
//                print("fail to get iam token")
//                return
//            }
//            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
//            if var responseJSON = responseJSON as? [String: String] {
//                DispatchQueue.main.async {
//                self.iamToken = responseJSON["iamToken"]!
//                    print(self.iamToken)
//                }
//            }
//        }
//        task.resume()
//        
//        print("success get Iam Token")
//        
//        
//    }
//    
//    
//    //MARK: GET CLOUD ID
//        
////    public func getCloudId(){
////        let cloudUrl = URL(string: "https://resource-manager.api.cloud.yandex.net/resource-manager/v1/clouds")
////
////        var requestForClouds = URLRequest(url: cloudUrl!, timeoutInterval: Double.infinity)
////        requestForClouds.httpMethod = "GET"
////        requestForClouds.setValue("Bearer \(iamToken)", forHTTPHeaderField: "Authorization")
////
////        let cloudsTask = URLSession.shared.dataTask(with: requestForClouds) { data, response, error in
////            guard error == nil, data != nil, response != nil else {
////                print("fail to get list of clouds")
////                return
////            }
////
////            var dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
////            var dictionaryArray = dictionary as! [String : Any]
////            var arrayOfDict = dictionaryArray["clouds"] as! [[String: Any]]
////            for ar in arrayOfDict {
////                self.cloud_id = ar["id"] as! String
////            }
////            print(self.cloud_id)
////        }
////        cloudsTask.resume()
////        
////        print("success get cloud_id")
////    }
//}
//    
//    
//
