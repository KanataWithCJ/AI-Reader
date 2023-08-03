//
//  GPTView.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/5.
//

import SwiftUI
import OpenAISwift
import ExpandableText

enum SheetMode{
    case combine
    case chatgpt
}
struct GPTView:View{
    @ObservedObject var texteditViewModel:TextEditViewModel
    @Binding var models:[String]
    @State var question:String = ""
    @State var sent_text:String = ""
    @ObservedObject var gptViewModel:ViewModel
    @ObservedObject var collectionViewModel:CollectionViewModel
    @State var is_activated:Bool = false
    @State var is_combine:Bool = false
    @State var mode:SheetMode = .chatgpt
    @State var is_collected:Bool = false
    @Environment(\.editMode) private var editMode
    var body: some View{
        VStack(alignment:.leading){
            HStack{
                Text("Scanned Text:").bold()
                Spacer()
                Button("Clear"){
                    texteditViewModel.Clear()
                    models.removeAll()
                }
                Button(action: {
                    self.mode = .combine
                    is_activated.toggle()
                    sent_text = ""
                    texteditViewModel.ParaList.forEach{para in
                        if para.is_chosen{
                            sent_text += " " + para.entity
                        }
                    }
                }){
                    RoundedRectangle(cornerRadius: 5).frame(width:60,height: 20).foregroundColor(.blue)
                        .overlay{
                            Text("Edit").foregroundColor(.white)
                        }
                }
            }
            ScrollView{
                LazyVStack{
                    ForEach(texteditViewModel.ParaList, id: \.self){para in
                        VStack{
                            HStack{
                                ExpandableText(text: para.entity)
                                    .lineLimit(3)
                                    .expandButton(TextSet(text: "more", font: .body, color: .blue))
                                    .collapseButton(TextSet(text: "close", font: .body, color: .blue))
                                    .expandAnimation(.easeOut)
                                Spacer()
                                VStack{
                                    Button(action: {texteditViewModel.Toggle(idx: para.id)}, label: {
                                        if para.is_chosen{
                                            Image(systemName: "circle.circle.fill").resizable().foregroundColor(.blue)
                                        }else{
                                            Image(systemName: "circle.circle").resizable().foregroundColor(.blue)
                                        }
                                    }).frame(width: 20,height: 20)
                                    Spacer()
                                    Button(action: {
                                        texteditViewModel.ParaList.remove(at: para.id)
                                    }){
                                        RoundedRectangle(cornerRadius: 5).frame(width:40,height: 20).foregroundColor(.red).overlay{
                                            Text("Del").foregroundColor(.white)
                                        }
                                    }
                                }
                            }
                            Divider().foregroundColor(.blue)
                        }
                    }
                    .onDelete{texteditViewModel.Remove(index:$0)}
                    .onMove{texteditViewModel.Move(from: $0, to: $1)}
                }
            }
//                .lineLimit(6)
            Spacer()
            Button(action: {
                self.mode = .chatgpt
                if sent_text.isEmpty{
                    texteditViewModel.ParaList.forEach{para in
                        if para.is_chosen{
                            sent_text += " " + para.entity
                        }
                    }
                }
                if !sent_text.isEmpty{
                    withAnimation(.linear(duration: 0.5)){
                        models.append(sent_text)
                    }
                }
            
                is_activated.toggle()
//                models.append(sent_text)
            }, label: {
                RoundedRectangle(cornerRadius: 10).frame(width: 400,height: 50).foregroundColor(.green)
                    .overlay(alignment: .center){
                        Text("Ask GPT")
                            .foregroundColor(.white)
                    }
            })
        }
        .sheet(isPresented: $is_activated){
            if mode == .chatgpt{
                VStack(alignment: .leading){
                    
                    ScrollViewReader{ proxy in
                        ScrollView{
                            ForEach(models, id: \.self.hashValue ){string in
                                BubbleView(string: string)
                                    .id(string.hashValue)
                            }
                        }
//                        .onAppear{
//                            proxy.scrollTo(models.last?.hashValue)
//                        }
                        .onChange(of: models.count){ _ in
                            withAnimation(.linear(duration: 0.5)){
                                proxy.scrollTo(models.last?.hashValue, anchor:.bottom )
                            }
                        }
                            
                    }
                    
                    
                    
                    Spacer()
                    VStack(alignment:.leading){
                        HStack{
                            Button(action:{
                                send(question: "Summarize it")
                            }){
                                RoundedRectangle(cornerRadius: 10).frame(width:100,height: 20).foregroundColor(.gray).overlay{
                                    Text("Summarize it").font(.caption).foregroundColor(.white)
                                }
                            }
                            
                            Button(action:{
                                send(question: "How many words are in the text")
                            }){
                                RoundedRectangle(cornerRadius: 10).frame(width:120,height: 20).foregroundColor(.gray).overlay{
                                    Text("How many words").font(.caption).foregroundColor(.white)
                                }
                            }
                            
                            Button(action:{
                                send(question: "Translate the text to Chinese")
                            }){
                                RoundedRectangle(cornerRadius: 10).frame(width:140,height: 20).foregroundColor(.gray).overlay{
                                    Text("Translate to Chinese").font(.caption).foregroundColor(.white)
                                }
                            }
                        }
                        HStack{
                            TextField("Type here...",text:$question)
                            Button("Send"){
                                send(question:question)
                            }
                        }.padding(.horizontal)
                    }
                }
            }else if mode == .combine{
                VStack{
                    ScrollView{
                        HStack{
                            Spacer()
                            Button(action: {
                                if(self.is_collected){
                                    let itemToDelete = collectionViewModel.CollectList.first{ item in
                                        item.text == sent_text
                                    }
                                    collectionViewModel.Remove(item: itemToDelete!)
                                }
                                else{
                                    collectionViewModel.Append(text: sent_text)
                                }
                                self.is_collected.toggle()
                                
                            }){
                                if self.is_collected{
                                    Image(systemName: "star.fill").resizable().foregroundColor(.yellow).frame(width: 20,height: 20)
                                }else{
                                    Image(systemName: "star").resizable().foregroundColor(.yellow).frame(width: 20,height: 20)
                                }
                            }
                        }
                            TextField("Text to send",text: $sent_text,axis: .vertical)
                                .multilineTextAlignment(.leading)
                    }.padding().background{
                        RoundedRectangle(cornerRadius: 10).foregroundColor(.gray)
                    }
                }
            }
        }
        .onChange(of: sent_text){_ in
            is_collected = false
        }
        .padding()
    }
    
    struct BubbleView: View{
        var string: String
        var body: some View{
            
            if string.starts(with: "Response"){
                ChatBubble(direction: .right) {
                    Text(string)
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                }
            }else{
                ChatBubble(direction: .left) {
                    Text(string)
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
            }
        }
    }
    
    func send(question:String){
        
        guard !question.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let completeQuestion = sent_text + ". \r\n According to the text above, please answer the question: " + question
//        models.append(sent_text)
        withAnimation(.linear(duration: 0.5)){
            models.append("Question:\(question)")
        }
        gptViewModel.send(text:completeQuestion){response in
            DispatchQueue.main.async{
                withAnimation(.linear(duration: 0.5)){
                    self.models.append("Response:\(response)")
                }
            }
        }
    }
}
