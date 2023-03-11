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
    @State var showPhotoPicker: Bool = false
    
    var body: some View {
        TTView(content: {
            GeometryReader { proxy in
                Circle()
                    .offset(x:-proxy.frame(in: .global).midX + 30,y:-proxy.frame(in: .local).midY)
                    .fill(LinearGradient(colors: [.blue,.red], startPoint: .leading, endPoint: .trailing))
                    .shadow(radius: 8)
            }
            ScrollView {
                VStack {
                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "isim")
                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Soy İsim")
                    AdressInformationTextEditorView(addressText: $addressText)
                    
                    NewTTTextField(text: $textFieldText, errorHandleText: errorMesj, height: 40, placeholder: "Kullanıcı")
                
                    PhotosSelector()
                    
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


/// Sub View
struct AdressInformationTextEditorView: View {
    
    @Binding var addressText: String
    
    var body: some View {
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
    }
}

struct PhotosSelector: View {
    
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            PhotosPicker(selection:  $selectedItems) {
               Text("Lütfen Bina Kapı Bilgileri İçin Fotoğraf Yükleyin")
                    .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, minHeight: 35)
                .modifier(BaseButtonPrimaryModifier())
            }
        }.onChange(of: selectedItems) { value in
            guard let item = value.first else { return }
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let imageData):
                    debugPrint("success")
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    }
}

