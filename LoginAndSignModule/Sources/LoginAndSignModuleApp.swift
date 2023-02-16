//
//  LoginAndSignModuleApp.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.12.2022.
//

import SwiftUI
import LoginSignUpModule


@main
struct LoginAndSignModuleApp: App {
    
    
    
    var body: some Scene {
        WindowGroup {
            LoginViewScreen()
        }
    }
    private func setupNetworkEnvironment() {
    }
}


//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any])
//    -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }



//enum Environment: String {
//    case production = "production"
//    case development = "development"
//
//    var url: String {
//        switch self {
//        case .development:
//            return "https://development.base.url/"
//        case .production:
//            return "https://production.base.url/"
//        }
//    }
//
//    static var selected: Environment {
//        // Settings.bundle dosyasından okuma yapalım
//        let defaultValue = Environment.production
//
//        if let environment = UserDefaults.standard.string(forKey: "environment") {
//            return Environment(rawValue: environment) ?? defaultValue
//        }
//
//        return defaultValue
//        // Settings.bundle' ı göz ardı etmek isteyeceğimiz bir durum olursa,
//        // burada istediğimiz case i dönebiliriz
//    }
//
//}
