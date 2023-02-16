//
//  SwiftUIView.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.01.2023.
//

import SwiftUI

public struct TTPrimaryButton: View {
    
    public var clicked: (() -> Void)
    public var title: String
    public var titleColor: Color = .white
    public var backgroundColor: Color = .cyan
    
    public init(clicked: @escaping () -> Void,
                title: String,
                titleColor: Color = .white,
                backgroundColor: Color = .cyan) {
        self.clicked = clicked
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        
    }
    
    public var body: some View {
        Button {
            clicked()
        } label: {
            RoundedRectangle(cornerRadius: 8)
                .fill(backgroundColor)
                .overlay {
                    Text(title)
                        .foregroundColor(titleColor)
                        .padding(.horizontal)
                }
            
        }
    }
}

struct TTPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        TTPrimaryButton(clicked: {
            
        }, title: "")
    }
}
