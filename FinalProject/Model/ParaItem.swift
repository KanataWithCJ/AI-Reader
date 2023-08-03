//
//  ParaItem.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/5.
//

import Foundation

struct ParaItem:Hashable,Identifiable{
    var id:Int
    var entity:String
    var is_chosen:Bool = false
    mutating func Toggle(){
        is_chosen.toggle()
    }
}
