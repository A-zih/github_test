//
//  ContentView.swift
//  KdanTest
//
//  Created by Zih on 2022/7/27.
//

import SwiftUI

struct ContentView: View {
    
    var pageSize = 20
    var limit = 100
    
    @ObservedObject var userViewModel = UserViewModel()
    @State private var timer = 0
    @State private var currentPage = 1
    @State private var lastUserId = 0
    @State private var connected = true
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if !connected {
                    Text("Oops! 連線出問題了..")
                        .font(.title)
                }
                else {
                    HStack {
                        Button( action: {
                            //之前的使用者已存在array中，不用再call api
                            currentPage -= 1
                        }) {
                            Image(systemName: "arrow.left")
                        }
                        .disabled(currentPage == 1)
                        
                        Spacer()
                        
                        Text(String(currentPage))
                        
                        Spacer()
                        
                        Button( action: {
                            //下一頁
                            currentPage += 1
                            userViewModel.getUsers(limit: limit, pageSize: pageSize, since: lastUserId) { done in
                                guard let _ = done else { return }
                                
                                if let lastUser = userViewModel.users.last {
                                    lastUserId = lastUser.id
                                }
                            }
                        }) {
                            Image(systemName: "arrow.right")
                        }
                        .disabled(currentPage == Int(ceil(Double(limit) / Double(pageSize))))
                    }
                    .font(.title)
                    .frame(width: geometry.size.width * 0.6)
                    
                    
                    HStack {
                        Text("Timer: ")
                        Text(String(timer))
                        
                    }
                    .font(.title3)
                    .frame(width: geometry.size.width * 0.6)
                    .padding(5)
                    
                    ScrollView {
                        ForEach(0..<userViewModel.users.count, id:\.self) { i in
                            if i >= (currentPage - 1) * pageSize && i < currentPage * pageSize  {
                                
                                rowView(user: userViewModel.users[i], count: i + 1, geometry: geometry)
                            }
                        }
                    }
                }
               
            }
            .frame(width:geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            //抓取第一頁的資料
            userViewModel.getUsers(limit: limit, pageSize: pageSize, since: 0) { done in
                guard let done = done else { return }
                
                connected = done
                //得到這一頁最後一位user的id (用來獲取下一頁的開頭使用者id)
                if let lastUser = userViewModel.users.last {
                    lastUserId = lastUser.id
                }
                
            }
            
            //開啟計時器
            DispatchQueue.global(qos: .background).async {
                let timerTask = Timer(timeInterval: 1, repeats: true) { _ in
                    timer += 1
                }
                let runLoop = RunLoop.current
                runLoop.add(timerTask, forMode: .default)
                runLoop.run()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct rowView: View {
    var user: User
    var count: Int
    var geometry: GeometryProxy
    @State var showingSheet = false
    var body: some View {
        Button (action: {
            showingSheet = true
        }) {
            HStack {
                Spacer()
                
                Text("No." + String(count))
                    .font(.title2)
                    .foregroundColor(.black)
                
                Spacer()
                
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 75, height: 120)
                
                Spacer()
    
                VStack {
                    Text("login: " + String(user.login))
                        .foregroundColor(.blue)
                    Text("site_admin: " + String(user.site_admin))
                        .foregroundColor(.red)
                    Text("user id: " + String(user.id))
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
           
        }
        .frame(width: geometry.size.width)
        .sheet(isPresented: $showingSheet) {
            UserInfoView(user: user)
        }
    }
}
