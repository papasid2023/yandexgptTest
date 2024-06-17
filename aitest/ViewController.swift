//
//  ViewController.swift
//  aitest
//
//  Created by Руслан Сидоренко on 26.05.2024.
//

import UIKit

class ViewController: UIViewController {
    
    public var iamToken: String = ""
    public var cloud_id: String = ""
    public var folders_id: String = ""
    
    public var messageAnswer: String = ""
    
    let textField = UITextView()
    let postRequest = UIButton()
    
    let answerField = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupAnswerTextField()
        hideKeyboard()
        getIamToken()
    }
   
        private func setupAnswerTextField(
            answerText: String = ""
        ){
            view.addSubview(answerField)
            answerField.backgroundColor = .secondarySystemBackground
            answerField.clipsToBounds = true
            answerField.layer.cornerRadius = 15
            answerField.isUserInteractionEnabled = false
            answerField.frame = CGRect(x: 18,
                                     y: 54,
                                     width: Int(view.frame.width) - 36,
                                     height: Int(view.frame.height)/3)
            answerField.textAlignment = .natural
            answerField.text = answerText
            answerField.contentMode = .topLeft
            answerField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            answerField.isScrollEnabled = false
        }
    
        private func setupUI(){
            view.addSubview(textField)
            textField.backgroundColor = .secondarySystemBackground
            textField.clipsToBounds = true
            textField.autocorrectionType = .no
            textField.layer.cornerRadius = 15
            textField.frame = CGRect(x: 18,
                                     y: 400,
                                     width: Int(view.frame.width) - 36,
                                     height: Int(view.frame.height)/3)
            textField.textAlignment = .natural
            textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            
            let label = UILabel()
            view.addSubview(label)
            label.text = "Задайте свой вопрос ниже"
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.frame = CGRect(x: 18,
                                 y: Int(textField.frame.minY)-30,
                                 width: 250,
                                 height: 20)
    
            view.addSubview(postRequest)
            postRequest.setTitle("ОТПРАВИТЬ", for: .normal)
            postRequest.clipsToBounds = true
            postRequest.layer.cornerRadius = 15
            postRequest.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            postRequest.backgroundColor = .tertiarySystemGroupedBackground
            postRequest.setTitleColor(.black, for: .normal)
            postRequest.frame = CGRect(x: Int(view.frame.midX)-100,
                                       y: Int((view.frame.height)/3)+450,
                                       width: 200,
                                       height: 50)
            postRequest.addTarget(self, action: #selector(didTapGetPostRequestButton), for: .touchUpInside)
    
        }
    
        @objc func didTapGetPostRequestButton(){
    
            
    
            let object = requestObject(modelUri: "gpt://\(folders_id)/yandexgpt-lite",
                                       completionOptions: .init(stream: false, temperature: 0.6, maxTokens: 250),
                                       messages: [.init(role: "user", text: textField.text ?? "")])
    
            let postUrl = URL(string: "https://llm.api.cloud.yandex.net/foundationModels/v1/completion")
    
            var postRequest = URLRequest(url: postUrl!, timeoutInterval: Double.infinity)
            postRequest.httpMethod = "POST"
            postRequest.setValue("Bearer \(iamToken)", forHTTPHeaderField: "Authorization")
            postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            postRequest.setValue(folders_id, forHTTPHeaderField: "x-folder-id")
            postRequest.httpBody = try? JSONEncoder().encode(object)
    
    
            let postTask = URLSession.shared.dataTask(with: postRequest) { data, response, error in
                guard error == nil, data != nil, response != nil else {
                    print("fail to get iam token")
                    return
                }
               
    
                var dataPost = try? JSONSerialization.jsonObject(with: data!, options: [])
    
                var dataPostArray = dataPost as! [String : Any]
                var arrayOfDataPostArray = dataPostArray["result"] as! [String: Any]
    
                var alternativeArray = arrayOfDataPostArray["alternatives"] as! [[String: Any]]
    
                var message: [String: Any] = [:]
    
                for array in alternativeArray {
                    message = array["message"] as! [String: Any]
                }
    
                DispatchQueue.main.async {
                    self.setupAnswerTextField(answerText: message["text"] as! String)
                    self.textField.text = nil
                }
            }
            postTask.resume()
            print(self.messageAnswer)
    
        }
    
    
    
    func getIamToken() {
    
            let myOauthToken = "y0_AgAAAAAFSi2nAATuwQAAAAEF2dcLAAD6qDJONxpCCpQ9VXtCqRQCSojrcg"
    
            //get iam token
    
            let url = URL(string: "https://iam.api.cloud.yandex.net/iam/v1/tokens")
            var request = URLRequest(url: url!, timeoutInterval: Double.infinity)
            request.httpMethod = "POST"
            let body = ["yandexPassportOauthToken": myOauthToken]
            let bodyData = try? JSONSerialization.data(
                withJSONObject: body,
                options: []
            )
            request.httpBody = bodyData
    
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil, data != nil, response != nil else {
                    print("fail to get iam token")
                    return
                }
    
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if var responseJSON = responseJSON as? [String: String] {
                        self.iamToken = responseJSON["iamToken"]!
                        print("success get Iam Token")
                        print("iam token is: \(self.iamToken)")
                        self.getCloudIdFunc()
                    }
            }
            task.resume()
            
            
    
        }
    
    func getCloudIdFunc() {
    
            let cloudUrl = URL(string: "https://resource-manager.api.cloud.yandex.net/resource-manager/v1/clouds")
    
            var requestForClouds = URLRequest(url: cloudUrl!, timeoutInterval: Double.infinity)
            requestForClouds.httpMethod = "GET"
            requestForClouds.setValue("Bearer \(self.iamToken)", forHTTPHeaderField: "Authorization")
    
            let cloudsTask = URLSession.shared.dataTask(with: requestForClouds) { data, response, error in
                guard error == nil, data != nil, response != nil else {
                    print("fail to get list of clouds")
                    return
                }
                
               
                var dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                var dictionaryArray = dictionary as! [String : Any]
                var arrayOfDict = dictionaryArray["clouds"] as! [[String: Any]]
                for ar in arrayOfDict {
                    self.cloud_id = ar["id"] as! String
                    
                }
                print("success get cloud_id")
                print("iam cloud_id is: \(self.cloud_id)")
                self.getFolderIdFunc()
            }
            cloudsTask.resume()
        }
    
    func getFolderIdFunc() {
    
            var components = URLComponents(string: "https://resource-manager.api.cloud.yandex.net/resource-manager/v1/folders")!
    
            components.queryItems = [
                URLQueryItem(name: "cloud_id", value: self.cloud_id)
            ]
    
            let foldersUrl = components.url
    
            var requestForFolders = URLRequest(url: foldersUrl!, timeoutInterval: Double.infinity)
            requestForFolders.httpMethod = "GET"
            requestForFolders.setValue("Bearer \(self.iamToken)", forHTTPHeaderField: "Authorization")
    
            let folderTask = URLSession.shared.dataTask(with: requestForFolders) { data, response, error in
                guard error == nil, data != nil, response != nil else {
                    print("fail to get list of folders")
                    return
                }
    
                var dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                var dictionaryArray = dictionary as! [String : Any]
                var arrayOfDict = dictionaryArray["folders"] as! [[String: Any]]
                for ar in arrayOfDict {
                    self.folders_id = ar["id"] as! String
                }
                print("success get folder_id")
                print("iam folder_id is: \(self.folders_id)")
            }
            folderTask.resume()
        }
    }



