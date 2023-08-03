//
//  IntroView.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/6.
//

import SwiftUI

struct IntroView:View{
    @Binding var is_Intro:Bool
    var body: some View{
        VStack{
            Text("Introduction").bold().font(.largeTitle)
            Text("We scan text with livestream and evaluate with ChatGPT").font(.title2)
            VStack(alignment:.leading){
                Text("1. Live stream text scan")
                Text("2. Freely combine the texts")
                Text("3. Powerfull text analysis based on ChatGPT")
                Text("4. Add texts to your favorite list, permanent storage")
                Text("5. User information management")
            }
            Button("Let's go..."){
                is_Intro.toggle()
            }
        }
    }
}
