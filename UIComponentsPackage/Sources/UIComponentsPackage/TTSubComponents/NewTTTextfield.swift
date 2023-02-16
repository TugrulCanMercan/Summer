//
//  SwiftUIView.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 28.12.2022.
//

import SwiftUI

public struct NewTTTextField: View {
    @Binding var text: String
    var errorHandleText: String
    @State var height: CGFloat
    @State var placeholder: String
    var isSecureEnable: Bool = false
    
    public init(text:Binding<String>, errorHandleText: String, height: CGFloat = 30, placeholder: String,isSecureEnable: Bool = false) {
        self._text = text
        self.errorHandleText = errorHandleText
        self.height = height
        self.placeholder = placeholder
        self.isSecureEnable = isSecureEnable
    }
    
    public var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 8)
                .stroke()
                .overlay {
                    GeometryReader { geo in
                        ZStack {
                            if !errorHandleText.isEmpty {
                                Text(errorHandleText)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .frame(height: geo.size.height,alignment: .center)
                                    .offset(x: 10, y: -geo.size.height)
                                    .transition( .offset(x: 0, y: geo.size.height + 10).combined(with: .opacity))
                            }
                            if isSecureEnable {
                                SecureField(placeholder, text: $text)
                                    .padding(.horizontal)
                                        .foregroundColor(text.isEmpty ? .gray : .black)
                                        .frame(height: geo.size.height,alignment: .center)
                            } else {
                                TextField(placeholder, text: $text)
                                .padding(.horizontal)
                                    .foregroundColor(text.isEmpty ? .gray : .black)
                                    .frame(height: geo.size.height,alignment: .center)
                            }
                        }
                        .animation(.easeOut, value: errorHandleText)
                        .preference(key: BorderPrefrencesKey.self, value: geo.size.height)
                    }
                    
                }

                .frame(minHeight: 20)
                .frame(height: height)
            
        }
        .onPreferenceChange(BorderPrefrencesKey.self) { value in
            height = value
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 20)
        .frame(height: height + 25)
        
    }
}

struct BorderPrefrencesKey:PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
    typealias Value = CGFloat
    
    
}

struct NewTTTextField_Previews: PreviewProvider {
    static var previews: some View {

        NewTTTextField(text: .constant("qwe"), errorHandleText: "a", placeholder: "Login")
    }
}
