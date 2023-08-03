//
//  CollectItem.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/6.
//

import Foundation
struct CollectItem:Hashable,Identifiable{
    var id:String = UUID().uuidString
    var text:String
}
