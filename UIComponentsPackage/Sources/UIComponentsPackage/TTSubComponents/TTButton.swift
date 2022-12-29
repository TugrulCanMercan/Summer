//
//  TTButton.swift
//  BitirmeProjesi
//
//  Created by Tuğrulcan on 8.04.2022.
//

import SwiftUI

public struct TTButton: View {
    var text: String
    var icon: Image?
    let color:Color
    var width:CGFloat?
    var clicked: (() -> Void)
    
    public init(text:String,icon:Image? = nil,clicked:@escaping (() -> Void),color:Color,width:CGFloat? = nil){
        self.text = text
        self.icon = icon
        self.clicked = clicked
        self.color = color
        self.width = width
    }
    public var body: some View {
        Button {
            clicked()
        } label: {
            
            Text(text)
                .frame(maxWidth: width)
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue, lineWidth: 4)
                )
            
            
            
            
        }
        
    }
}

struct TTButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TTButton(text: "selamdsdsdsd", icon: Image(systemName: "person"), clicked: {
                print("selam")
            }, color: .red)
        }

    }
}
