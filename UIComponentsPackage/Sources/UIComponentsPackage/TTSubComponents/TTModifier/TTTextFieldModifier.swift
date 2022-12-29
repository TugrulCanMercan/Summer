//
//  TTTextFieldModifier.swift
//  BitirmeProjesi
//
//  Created by Tuğrulcan on 8.04.2022.
//

import SwiftUI


public struct TTTextFieldModifier:ViewModifier{
    
    @Binding var text: String
    @State var color: Color
    public func body(content: Content) -> some View {
        
        HStack{
            content
                .padding(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(color, lineWidth: 2)
                        .background(alignment: .trailing, content: {
                            if !text.isEmpty {
                                Button(
                                    action: { self.text = "" },
                                    label: {
                                        Image(systemName: "delete.left")
                                            .foregroundColor(Color(UIColor.opaqueSeparator))
                                    }
                                ).padding([.horizontal])
                            }
                        })

                )
                
            
           
            
        }
        
    }
    
    
}
