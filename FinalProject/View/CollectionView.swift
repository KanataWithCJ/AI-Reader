//
//  CollectionView.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/6.
//

import SwiftUI
import ExpandableText
struct CollectionView:View{
    @ObservedObject var texteditViewModel:TextEditViewModel
    @ObservedObject var collectionViewModel:CollectionViewModel
//    @Environment(\.editMode) private var editMode
    var body: some View{
        VStack{
            Text("Favorite List").bold()
            ScrollView{
                LazyVStack{
                    ForEach(collectionViewModel.CollectList){collect in
                        VStack(alignment: .leading){
                            HStack{
                                ExpandableText(text: collect.text)
                                    .lineLimit(3)
                                    .expandButton(TextSet(text: "more", font: .body, color: .blue))
                                    .collapseButton(TextSet(text: "close", font: .body, color: .blue))
                                    .expandAnimation(.easeOut)
                                Spacer()
                                VStack{
                                    Button(action:{
                                        texteditViewModel.Append(entity: collect.text, is_chosen: false)
                                    }){
                                        RoundedRectangle(cornerRadius: 5).frame(width:60,height: 20).foregroundColor(.blue)
                                            .overlay{
                                                Text("Add").foregroundColor(.white)
                                            }
                                    }
                                    Spacer()
                                    Button(action:{
                                        collectionViewModel.Remove(item: collect)
                                    }){
//                                        collectionViewModel.CollectList.remove(at: index!)
                                        RoundedRectangle(cornerRadius: 5).frame(width:60,height: 20).foregroundColor(.red)
                                            .overlay{
                                                Text("Delete").foregroundColor(.white)
                                            }
                                    }
                                }
                            }.padding(.horizontal)
                            Divider().foregroundColor(.blue)
                        }
                    }
                }
            }
        }
    }
}
