//
//  TTSecureField.swift
//  BitirmeProjesi
//
//  Created by Tuğrulcan on 8.04.2022.
//

import SwiftUI

public struct TTSecureField: View {
    @State var placeHolder:String
    var errorhanlde:String
    @Binding var text:String
    @State var borderColor: Color = .black
    public init(
        placeHolder:String,
        errorhanlde:String = "",
        text:Binding<String>
    ){
        self._text = text
        self.errorhanlde = errorhanlde
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
        
        
        VStack(alignment:.leading){
            GeometryReader{geo in
                VStack(alignment:.leading){
                    
                    VStack{
                        if !errorhanlde.isEmpty{
                            Text(errorhanlde)
                                .foregroundColor(.red)
                                .font(.caption)
                                .offset(x: 10, y: 0)
                                .transition( .offset(x: 0, y: 50).combined(with: .opacity))
                                .frame(height:20)
                        }else{
                            Color.clear
                                .frame(height:20)
                                
                        }
                    }
                    .animation(.easeOut, value: errorhanlde)
                    SecureField(placeHolder, text: $text)
                        .modifier(TTTextFieldModifier(text: $text, color: borderColor))
                    
                }
                

            }

        }

        .frame(height: 75)
        
       
        
        
        
    }
}

struct TTSecureField_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            
        }
    }
}
