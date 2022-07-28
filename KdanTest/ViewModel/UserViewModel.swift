//
//  UserViewModel.swift
//  KdanTest
//
//  Created by Zih on 2022/7/27.
//

import Foundation

class UserViewModel: ObservableObject {
    @Published var users = [User]()
    
    func getUsers(limit: Int, pageSize: Int, since: Int, completion: @escaping (Bool?) -> ()) {
        
        guard let url = URL(string: "https://api.github.com/users?since=" + String(since) + "&per_page=" + String(pageSize)) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if data == nil {
                completion(false)
            }
            else {
                let users = try! JSONDecoder().decode([User].self, from: data!)
                DispatchQueue.main.async {
                    //最多存limit個
                    if self.users.count < limit {
                        self.users.append(contentsOf: users)
                        
                        //超過就丟掉
                        if self.users.count > limit {
                            self.users = self.users.dropLast(self.users.count - limit)
                        }
                    }
                    completion(true)
                }
            }
            
        }
        .resume()
    }
    
}
