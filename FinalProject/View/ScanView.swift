//
//  ScanView.swift
//  FinalProject
//
//  Created by 从径源 on 2023/6/5.
//

import  SwiftUI

struct ScanView:View{
    @ObservedObject var vsViewModel:VSKitViewModel
    @ObservedObject var texteditViewModel:TextEditViewModel
    @State var is_added:Bool = false
    @State var show_line:String = ""
    var body: some View{
        VStack{
            ScannerView(recognizedEntities: self.$vsViewModel.recognizedEntities, recognizedDataTypes: self.vsViewModel.scanmode, recognizesMultipleItems: self.vsViewModel.multipleItems).id(vsViewModel.scannerViewId)
            if !vsViewModel.recognizedEntities.isEmpty{
                switch vsViewModel.recognizedEntities[0]{
                case .text(let text_entity):
                    Text(text_entity.transcript)
                default:
                    Text("Scanning...").bold().foregroundColor(.green)
                }
            }else{
                Text("Scanning...").bold().foregroundColor(.green)
            }
            HStack{
                Button(action:{
                    self.is_added.toggle()
                    show_line = ""
                    if !vsViewModel.recognizedEntities.isEmpty{
                        switch vsViewModel.recognizedEntities[0]{
                        case .text(let text_entity):
                            show_line = text_entity.transcript
                        default:
                            _ = ""
                        }
                    }
                }){
                    RoundedRectangle(cornerRadius: 5).frame(width:60,height: 20).foregroundColor(.blue)
                        .overlay{
                            Text("Clip").foregroundColor(.white)
                        }
                }.padding()
            }
        }
        .alert(isPresented: $is_added){
            Alert(title: Text("Add text?"), message: Text(show_line),
                  primaryButton: .default(
                      Text("Yes"),
                      action: {
                          texteditViewModel.Append(entity: show_line, is_chosen: false)
                      }
                  ),
                  secondaryButton: .destructive(
                      Text("No"),
                      action: {
                          print("Delete")
                      }
                  ))
        }
    }
}
