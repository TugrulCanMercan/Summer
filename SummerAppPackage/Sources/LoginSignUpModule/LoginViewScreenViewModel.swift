//
//  File.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.01.2023.
//

import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import Firebase
import UIComponentsPackage

class LoginViewScreenViewModel: TTMNavbarViewModel {
    
    func googleAuth() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: .getRootViewController()) { currentAuthUser, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let authentication = currentAuthUser?.user.accessToken, let idToken = currentAuthUser?.user.idToken
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: authentication.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                
                // User is signed in
                // ...
            }
        }
    }
    func getId() {
        
    }

}
