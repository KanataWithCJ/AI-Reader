//
//  FinalProjectApp.swift
//  FinalProject
//
//  Created by User1 on 2023/6/4.
//

import SwiftUI
import LeanCloud

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        

        do {
            // 延长LaunchScreen中的时间
            Thread .sleep(forTimeInterval: 1.0)
            try LCApplication.default.set(
                id: "wzE3EaqWiDO4QAR9tc6jWROC-gzGzoHsz",  // your-app-id,
                key: "KfUNctfmaLmynoheecMcenlA",  // your-app-key,
                serverURL: "https://wze3eaqw.lc-cn-n1-shared.com") // your_server_url
        } catch {
            print(error)
        }
        // 在 Application 初始化代码执行之前执行，debug用
        LCApplication.logLevel = .all
        return true
    }
}


@main
struct FinalProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            // 检测当前账户的登录状态
            if let _ = LCApplication.default.currentUser {
                // 跳到首页
                ContentView()
            } else {
                // 显示注册或登录页面
                LoginView()
            }
        }
    }
}
