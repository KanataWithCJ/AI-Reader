//
//  VSKitViewModel.swift
//  VisionKitDemo
//
//  Created by 从径源 on 2023/5/19.
//

import Foundation
import SwiftUI
import VisionKit


class VSKitViewModel:ObservableObject{
    @Published var recognizedEntities:[RecognizedItem] = []
    @Published var scanmode:DataScannerViewController.RecognizedDataType = .barcode()
    @Published var multipleItems:Bool = true
    @Published var recogizedcontents:String = ""
    var scannerViewId:Int{
        var hasher = Hasher()
        hasher.combine(scanmode)
        hasher.combine(multipleItems)
        return hasher.finalize()
        
    }
}
