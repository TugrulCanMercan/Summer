//
//  ContentView.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.12.2022.
//

import SwiftUI
import UIComponentsPackage
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth
import Firebase

public struct LoginViewScreen: View {
    @State var show = false
    @State var textFieldText:String = ""
    @State var errorMesj = ""
    @StateObject var loginViewModel = LoginViewScreenViewModel(navbartitle: "Project Cafe")
    
    public init() {}
    
    public var body: some View {
        TTMNavbar(content: {
            TTView(content: {
                GeometryReader { proxy in
                    Circle()
                        .offset(x:-proxy.frame(in: .global).midX + 30,y:-proxy.frame(in: .local).midY)
                        .fill(LinearGradient(colors: [.blue,.red], startPoint: .leading, endPoint: .trailing))
                        .shadow(radius: 8)
                    
                    VStack{
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 75,height: 75)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke()
                                    .stroke(lineWidth: 3)
                                    .frame(width: 95,height: 95)
                                    .background(Color.indigo.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        
                        
                        GeometryReader { subProxy in
                            VStack{
                                NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Kullanıcı")
                                NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Şifre",isSecureEnable: true)
                                
                                VStack {
                                    TTPrimaryButton(clicked: {
                                        
                                    }, title: "Giriş",backgroundColor: .blue)
                                    .frame(height: 50)
                                    
                                    
                                    TTButton(text: "Kayıt Ol", clicked: {
                                        loginViewModel.appendStack(stackItem: Model(title: "Kayıt Ol"))
                                        
                                    }, color: .black,width: .infinity,height: 30)

                                    Button {
                                        
                                    } label: {
                                        HStack{
                                            Grid {
                                                GridRow {
                                                    Rectangle()
                                                        .frame(maxWidth: .infinity)
                                                    .gridCellColumns(1)
                                                    .gridCellAnchor(.leading)
                                                    
                                                    VStack {Image(systemName: "person")}
                                                    .gridCellColumns(1)
                                                    .gridColumnAlignment(.center)
                                                    
                                                    
                                                }
                                                
                                        
                                            }
                                            .frame(maxWidth: .infinity)
                                            
                                        }
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                            .frame(maxHeight: 30)
                                            .padding(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.blue, lineWidth: 4)

                                            )
                                    }

                                    
                                }
                                .padding(.vertical)
                            }
                            .frame(alignment: .center)
                        }
                        
                        Spacer()
                        
                    }
                    .destionationNavBar(hadler: { (val:Model) in
                        SignUpScreenView()
                    })
                    .frame(height: proxy.size.height,alignment: .center)
                    .padding()
                    .padding(.vertical)
                    
                    
                    if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("Version:\(text)")
                            .padding(.horizontal,20)
                            .frame(width: proxy.frame(in: .local).width, height: proxy.frame(in: .local).maxY,alignment: .bottomTrailing)
                    }
                    
                    
                }
                
                
            }, popUpContent: {
                VStack{
                    Text("pOP up")
                }
            }, showActivate: $show)
            
            
        }, ttMNavbarViewModel: loginViewModel)
    }
    
    func configration() -> TTMNavbarViewModel {
        let navbarViewModel = TTMNavbarViewModel(navbartitle: "Giriş")
        return navbarViewModel
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewScreen()
    }
}

// Taşınmalı Helper
extension UIViewController {
    static func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
