//
//  SignUpScreenView.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.01.2023.
//

import SwiftUI
import UIComponentsPackage
import PhotosUI

struct SignUpScreenView: View {
    @State var errorMesj = ""
    @State var textFieldText = ""
    @State var addressText = ""
    var body: some View {
        TTView(content: {
            GeometryReader { proxy in
                Circle().offset(x:-proxy.frame(in: .global).midX,y:-proxy.frame(in: .global).midY + 50)
                    .fill(Color.yellow)
            }
            
            ScrollView {
                
                VStack {
                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "isim")
                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Soy İsim")
                    VStack(spacing:0) {
                        Text("Adres Bilgisi")
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .foregroundColor(.black.opacity(0.7))
                        TextEditor(text: $addressText)
                            .scrollContentBackground(.hidden)
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(Color(uiColor: .systemGray4))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(1)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                    }

                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Kullanıcı")
                    
                    BaseButton(onClicked:{
                        
                    },placeHolder: "Lütfen Bina Kapı Bilgileri İçin Fotoğraf Yükleyin")
                    .frame(maxWidth: .infinity, minHeight: 35)
                    .modifier(BaseButtonPrimaryModifier())
                    
                    Spacer()
                }
                .padding()
            }

            
        },popUpContent: {
            
        },showActivate: .constant(false))
        
    }
}

struct SignUpScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreenView()
    }
}