//
//  LoginView.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/6.
//

import SwiftUI
import LeanCloud


struct LoginView: View {
    
    
    @State var username : String = ""
    @State var password : String = ""
    @State var is_Intro:Bool = true
    @State var showAlert :Bool = false
    @State var alertInfo: String = ""
    @State var go_to_content:Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    HelloText()
                    UserImage()
                    UsernameTextField(username: $username)
                    PsswordSecureField(password: $password)
                    
                    Button(action: {
                        login()
                    }){
                        LoginButtonContent()
                    }
                    
                    NavigationLink(destination: RegisterView(login_username: $username, login_password: $password)){
                        Text("No account? Register here.")
                            .foregroundColor(.blue)
                    }
                    
                }
                .padding()
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("Prompt"), message: Text(alertInfo))
            }
            .sheet(isPresented: $is_Intro){
                IntroView(is_Intro: $is_Intro)
            }
            .fullScreenCover(isPresented: $go_to_content, content: {
                ContentView()
            })
        }
//        .navigationViewStyle(.stack) //ipad 调整为大iphone模式，避免navigaiton变为侧栏
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
    
    struct LoginButtonContent: View {
        var body: some View {
            Text("Login")
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(width: 220, height: 60)
                .background(.white)
                .cornerRadius(35)
        }
    }
    
    struct UsernameTextField: View {
        @Binding var username :String
        var body: some View {
            TextField("Username", text: $username)
                .padding()
                .background(.gray)
                .foregroundColor(.black)
                .cornerRadius(5.0)
                .padding(.bottom,20)
        }
    }
    
    struct PsswordSecureField: View {
        @Binding var password :String
        var body: some View {
            SecureField("Password", text: $password)
                .padding()
                .background(.gray)
                .cornerRadius(5.0)
                .padding(.bottom,20)
        }
    }
    
    func login(){
        _ = LCUser.logIn(username: username, password: password) { result in
            switch result {
            case .success(object: _):
                self.go_to_content = true
                break;
            case .failure(error: let error):
                
                if error.code == 210 || error.code == 211{
                    alertInfo = error.failureReason ?? "Unknown Error"
                    showAlert = true
                    break;
                }
                else{
                    print(error)
                    alertInfo = "System error, please try again later." //基本不会发生
                    showAlert = true
                }
            }
        }
//        let query = LCQuery(className: "UserInfo")
//        query.whereKey("UserName", .equalTo(username))
//        _ = query.find { result in
//            switch result {
//            case .success(objects: let users):
//                if users.isEmpty{
//                    alertInfo = "Username not exist!"
//                    showAlert = true
//                    break;
//                }
//                let user = users[0]
//                if user["Password"]?.stringValue != password.sha256{
//                    alertInfo = "Wrong password!"
//                    showAlert = true
//                    break;
//                }
//                self.go_to_content = true
//                break;
//
//            case .failure(error: let error):
//                alertInfo = "System error, please try again later." //基本不会发生
//                showAlert = true
//                print(error)
//                break;
//            }
//        }
    }
//    func goToContentView(){
//        if let window = UIApplication.shared.connectedScenes
//            .map({ $0 as? UIWindowScene })
//            .compactMap({ $0 }).first?.windows.first
//        {
//            window.rootViewController = UIHostingController(rootView: ContentView())
//            window.makeKeyAndVisible()
//        }
//    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
