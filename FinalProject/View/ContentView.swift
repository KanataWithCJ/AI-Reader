//
//  ContentView.swift
//  FinalProject
//
//  Created by User1 on 2023/6/4.
//

import SwiftUI
import OpenAISwift

final class ViewModel : ObservableObject {
    init(){}
    private var client:OpenAISwift?
    func setup(){
        client = OpenAISwift(authToken:"5043c4ae2ebe45d99e9cb6e92f77aee6")
    }
    func send(text:String,
              completion:@escaping (String)->Void){
        client?.sendChat(with: [.init(role: .user, content: text)] , completionHandler: { result in
            switch result{
            case .success(let model):
                let output = model.choices?.first?.message
                completion(output?.content ?? "No response.")
            case .failure:
                break
            }
        })
    }
}

enum Tab {
    case scan
    case gpt
    case favorite
    case user
}

struct ContentView: View {
    
    @State private var selection: Tab = .scan
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var vsViewModel = VSKitViewModel()
    @ObservedObject var texteditViewModel = TextEditViewModel()
    @ObservedObject var collectViewModel = CollectionViewModel()
    @State var text = ""
    @State var question = ""
    @State var models = [String]()
    
    @State var is_activated:Bool = false
    init(){
        viewModel.setup()
        UITabBar.appearance().backgroundColor = .gray
    }
    
    var body: some View {
        NavigationView { //整体设置，下级页面不会在出现底部tabbar
            TabView(selection: $selection) {
                ScanView(vsViewModel: vsViewModel, texteditViewModel: texteditViewModel)
                    .tabItem{
                        Label("Scan", systemImage: "doc.viewfinder.fill")
                    }
                    .tag(Tab.scan)
                GPTView(texteditViewModel: texteditViewModel, models: $models, gptViewModel: viewModel, collectionViewModel: collectViewModel)
                    .tabItem{
                        Label("GPT", systemImage: "graduationcap.circle")
                    }
                    .tag(Tab.gpt)
                CollectionView(texteditViewModel: texteditViewModel, collectionViewModel: collectViewModel)
                    .tabItem{
                        Label("Favorite", systemImage: "star")
                    }
                    .tag(Tab.favorite)
                UserView()
                    .tabItem{
                        Label("User", systemImage: "person.circle")
                    }
                    .tag(Tab.user)
            }
            .accentColor(.gray) //设置文字默认选中颜色
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
