//
//  RegisterView.swift
//  
//
//  Created by User1 on 2023/6/8.
//

import SwiftUI
import LeanCloud
import CommonCrypto

struct RegisterView: View {
    
    
    @Binding var login_username : String
    @Binding var login_password : String
    @State var username : String = ""
    @State var password : String = ""
    @State var confirm_password : String = ""
    @State var is_Intro:Bool = true
    @State var showAlert :Bool = false
    @State var alertInfo: String = ""
    
    var body: some View {
        
        ZStack {
            VStack{
                HelloText()
                UserImage()
                UsernameTextField(username: $username)
                PsswordSecureField(password: $password)
                PsswordConfirmField(confirm_password: $confirm_password)
                Button(action: {
                    register()
                }){
                    RegisterButtonContent()
                }
            }
            .padding()
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Prompt"), message: Text(alertInfo))
        }
    }
    
    struct HelloText: View {
        var body: some View {
            Text("AI Reader")
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
    
    struct RegisterButtonContent: View {
        var body: some View {
            Text("Register")
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
    
    struct PsswordConfirmField: View {
        @Binding var confirm_password :String
        var body: some View {
            SecureField("Confirm Password", text: $confirm_password)
                .padding()
                .background(.gray)
                .cornerRadius(5.0)
                .padding(.bottom,20)
        }
    }
    
    func register(){
        if username == "" || password == "" || confirm_password == ""{
            alertInfo = "Username or password cannot be empty!"
            showAlert = true
            return
        }
        else if password != confirm_password {
            alertInfo = "Password does not match Confirm Password!"
            showAlert = true
            return
        }
        
        
        let newuser = LCUser()
        // 等同于 user.set("username", value: "Tom")
        newuser.username = LCString(username)
        newuser.password = LCString(password)

        _ = newuser.signUp { (result) in
            switch result {
            case .success:
                login_username = username
                login_password = password
                alertInfo = "Registered successfully!"
                showAlert = true
                break
            case .failure(error: let error):
                if error.code == 202{
                    alertInfo = "User name already exists!"
                    showAlert = true
                    break
                }
                else{
                    print(error)
                    alertInfo = "System error, please try again later." //基本不会发生
                    showAlert = true
                    break
                }
            }
        }
    }
}


//extension String {
//    /**
//     - returns: the String, as an Sha256 hash.
//     */
//    var sha256: String {
//        let utf8 = cString(using: .utf8)
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        CC_SHA256(utf8, CC_LONG(utf8!.count - 1), &digest)
//        return digest.reduce("") { $0 + String(format:"%02x", $1) }
//    }
//}
