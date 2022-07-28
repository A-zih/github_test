//
//  UserInfoView.swift
//  KdanTest
//
//  Created by Zih on 2022/7/28.
//

import SwiftUI

struct UserInfoView: View {
    var user: User
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                AsyncImage(url: URL(string: user.avatar_url)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 300)
                
                ScrollView {
                     VStack{
                         Group {
                             columnView(title: "login", value: user.login, width: geometry.size.width)
                             columnView(title: "id", value: String(user.id), width: geometry.size.width)
                             columnView(title: "node_id", value: user.node_id, width: geometry.size.width)
                             columnView(title: "avatar_url", value: user.avatar_url, width: geometry.size.width)
                             columnView(title: "gravatar_id", value: user.gravatar_id, width: geometry.size.width)
                             columnView(title: "url", value: user.url, width: geometry.size.width)
                             columnView(title: "html_url", value: user.html_url, width: geometry.size.width)
                             columnView(title: "followers_url", value: user.followers_url, width: geometry.size.width)
                             columnView(title: "following_url", value: user.following_url, width: geometry.size.width)
                             columnView(title: "gists_url", value: user.gists_url, width: geometry.size.width)

                         }
                         Group {
                             columnView(title: "starred_url", value: user.starred_url, width: geometry.size.width)
                             columnView(title: "subscriptions_url", value: user.subscriptions_url, width: geometry.size.width)
                             columnView(title: "organizations_url", value: user.organizations_url, width: geometry.size.width)
                             columnView(title: "repos_url", value: user.repos_url, width: geometry.size.width)
                             columnView(title: "events_url", value: user.events_url, width: geometry.size.width)
                             columnView(title: "received_events_url", value: user.received_events_url, width: geometry.size.width)
                             columnView(title: "type", value: user.type, width: geometry.size.width)
                             columnView(title: "site_admin", value: String(user.site_admin), width: geometry.size.width)
                         }
                       
                    }
                    
                }
            }
            .frame(width: geometry.size.width)
        }
        
    }
}

struct columnView: View {
    var title: String
    var value: String
    var width: CGFloat
    var body: some View {
        VStack {
            HStack {
                
                Text(title)
                    .frame(width: width * 0.5)
                Text(value)
                    .frame(width: width * 0.5)
            }
            .padding(.horizontal)
            
            Rectangle()
                .fill(Color.gray)
                .frame(width: width, height: 2)
        }
       
        
    }
}


struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
       
        UserInfoView(user: User(login: "", id: 0, node_id: "", avatar_url: "", gravatar_id: "", url: "", html_url: "", followers_url: "", following_url: "", gists_url: "", starred_url: "", subscriptions_url: "", organizations_url: "", repos_url: "", events_url: "", received_events_url: "", type: "", site_admin: false))
    }
}



