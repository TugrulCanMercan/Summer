//
//  ContentView.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.12.2022.
//

import SwiftUI
import UIComponentsPackage

struct ContentView: View {
    @State var show = false
    @State var textFieldText:String = ""
    @State var errorMesj = ""
    var body: some View {
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
                                NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, placeholder: "placeholder")
                                NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, placeholder: "placeholder")
                                VStack {

                                    TTButton(text: "Login", clicked: {
                                        
                                    }, color: .black,width: .infinity)
                                    
                                    TTButton(text: "Sign Up", clicked: {
                                        
                                    }, color: .black,width: .infinity)
                                }
                                .padding(.vertical)

                            }
                            .frame(height: subProxy.frame(in: .local).midY,alignment: .center)
                            
                        }

                        
                        

                        
                        Spacer()

                    }
                    .frame(height: proxy.size.height,alignment: .center)
                    .padding()
                    .padding(.vertical)
                }

            }, popUpContent: {
                VStack{
                    Text("pOP up")
                }
            }, showActivate: $show)

            
        }, ttMNavbarViewModel: configration())
    }
    
    func configration() -> TTMNavbarViewModel {
        let navbarViewModel = TTMNavbarViewModel(navbartitle: "Login")
        return navbarViewModel
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
