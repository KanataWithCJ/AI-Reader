//
//  CollectionViewModel.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/6.
//

import LeanCloud


class CollectionViewModel:ObservableObject{
    
    let user = LCApplication.default.currentUser
    
    @Published var CollectList:[CollectItem] = []
    
    init(){ // 从leancloud读取本用户已收藏的collectlist
        let query = LCQuery(className: "Collection")
        query.whereKey("username", .equalTo(user!.username!))
        
        _ = query.find { result in
            switch result {
            case .success(objects: let collections):
                if collections.isEmpty{ // 该用户目前没有collection
//                    self.CollectList = [] //跳过即可
                }
                else{
                    for collection in collections{
                        self.CollectList.append(CollectItem(id: collection["collectionID"]!.stringValue! , text: collection["text"]!.stringValue!))
                    }
                    break
                }
            case .failure(error: let error):
                print(error)
                break
            }
        }
    }
    
    func Append(text:String){
        do {
            let item = CollectItem(text: text)
            
            
            // 构建对象
            let newItem = LCObject(className: "Collection")

            // 为属性赋值
            try newItem.set("username", value: user!.username!)
            try newItem.set("text", value: item.text)
            try newItem.set("collectionID", value: item.id)
            
            // 将对象保存到云端
            _ = newItem.save { result in
                switch result {
                case .success:
                    // 成功保存之后，执行其他逻辑
                    break
                case .failure(error: let error):
                    // 异常处理
                    print(error)
                }
            }
            self.CollectList.append(item)
        } catch {
            print(error)
        }
        
    }
    
    func Remove(item: CollectItem){
        
        let index = CollectList.firstIndex(of: item)
        let query = LCQuery(className: "Collection")
        query.whereKey("collectionID", .equalTo(item.id))
        
        _ = query.find { result in
            switch result {
            case .success(objects: let collections):
                if collections.isEmpty{
                    return
                }
                let collection = collections[0]
                _ = collection.delete { result in
                    switch result {
                    case .success:
                        break
                    case .failure(error: let error):
                        print(error)
                    }
                }
                break
            case .failure(error: let error):
                print(error)
                break
            }
        }
        self.CollectList.remove(at: index!)
    }
    
    func Move(from:IndexSet,to:Int){
        self.CollectList.move(fromOffsets: from, toOffset: to)
    }
    
    func Clear(){
        self.CollectList.removeAll()
        
        let query = LCQuery(className: "Collection")
        query.whereKey("username", .equalTo(user!.username!))
        
        _ = query.find { result in
            switch result {
            case .success(objects: let collections):
                for collection in collections{
                    _ = collection.delete { result in
                        switch result {
                        case .success:
                            break
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    break
                }
            case .failure(error: let error):
                print(error)
                break
            }
        }
    }
}
