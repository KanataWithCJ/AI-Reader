//
//  UserView.swift
//  FinalProject
//
//  Created by User1 on 2023/6/9.
//

import SwiftUI
import LeanCloud


struct UserView: View {
    
    let user = LCApplication.default.currentUser
    @State var go_to_login:Bool = false
    
    let dateFormatter = DateFormatter()
    init(){
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    var body: some View {
        
            ZStack {
                VStack{
                    HelloText()
                    UserImage()
                    HStack{
                        Text("Username: ")
                        Text(user?.username?.stringValue ?? "Unknown User")
                    }
                    
                    HStack{
                        Text("Register time: ")
                        Text(dateFormatter.string(from: user?.createdAt?.dateValue ?? Date()))
                    }
                    
                    Button(action: {
                        LCUser.logOut()
                        if let _ = LCApplication.default.currentUser{
                            
                        }
                        else{
                            go_to_login = true
                        }
                    }){
                        LogoutButtonContent()
                    }
                    
                }
                .fullScreenCover(isPresented: $go_to_login, content: {
                    LoginView()
                })
                .padding()
            }
    }
    
    struct HelloText: View {
        var body: some View {
            Text("Hi,you")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom,20)
        }
    }
    
    struct UserImage: View {
        var body: some View {
            Image(systemName: "xbox.logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 130 , height: 130)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom,85)
        }
    }
    
    struct LogoutButtonContent: View {
        var body: some View {
            Text("Logout")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(width: 220, height: 60)
                .background(.white)
                .cornerRadius(35)
        }
    }
}

