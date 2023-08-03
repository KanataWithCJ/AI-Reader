//
//  ScannerViewCoordinator.swift
//  VisionKitDemo
//
//  Created by 从径源 on 2023/5/19.
//
import VisionKit
import SwiftUI
import Foundation
class Coordinator:NSObject,DataScannerViewControllerDelegate{
    @Binding var recognizedEntities:[RecognizedItem]
    init(recognizedEntities: Binding<[RecognizedItem]>) {
        self._recognizedEntities = recognizedEntities
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        print("didTapon \(item)")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        recognizedEntities.append(contentsOf: addedItems)
        print("didAdd \(addedItems)")
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        self.recognizedEntities = self.recognizedEntities.filter{ entity in
            removedItems.contains(where: {entity.id == $0.id})
        }
    }
}
