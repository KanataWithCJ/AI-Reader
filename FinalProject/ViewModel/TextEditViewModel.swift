//
//  TextEditViewModel.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/5.
//
import Foundation
import SwiftUI
class TextEditViewModel:ObservableObject{
    @Published var ParaList:[ParaItem] = []
    func Toggle(idx:Int){
        ParaList[idx].Toggle()
    }
    
    func Append(entity:String,is_chosen:Bool){
        self.ParaList.append(ParaItem(id: self.ParaList.count, entity: entity,is_chosen: is_chosen))
    }
    
    func Remove(index:IndexSet){
        self.ParaList.remove(atOffsets: index)
    }
    
    func Move(from:IndexSet,to:Int){
        self.ParaList.move(fromOffsets: from, toOffset: to)
    }
    
    func Clear(){
        self.ParaList.removeAll()
    }
}
