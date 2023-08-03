//
//  ScannerView.swift
//  VisionKitDemo
//
//  Created by 从径源 on 2023/5/19.
//

import Foundation
import SwiftUI
import VisionKit

struct ScannerView:UIViewControllerRepresentable{
    @Binding var recognizedEntities:[RecognizedItem]
    let recognizedDataTypes:DataScannerViewController.RecognizedDataType
    let recognizesMultipleItems:Bool
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let dsvc = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return dsvc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
//        uiViewController.recognizesMultipleItems = recognizesMultipleItems
        try?uiViewController.startScanning()
    }
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedEntities: self.$recognizedEntities)
    }
}

