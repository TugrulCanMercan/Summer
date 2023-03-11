//
//  SwiftUIView.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 2.03.2023.
//

import SwiftUI

public struct BaseButton: View {
    
    public var onClicked: (() -> Void)?
    public var placeHolder: AttributedString?
    
    public init(onClicked: (() -> Void)? = nil,
         placeHolder: AttributedString? = nil) {
        self.onClicked = onClicked
        self.placeHolder = placeHolder
    }
    
    public var body: some View {
            Button {
                onClicked?()
            } label: {
                VStack {
                    Text(placeHolder ?? "DS")
                        .foregroundColor(Color.white)
                }
            }
    }
}

struct SwiftUIViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        BaseButton(placeHolder: "neler")
            .modifier(BaseButtonPrimaryModifier())
    }
}

public struct BaseButtonPrimaryModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .padding(4)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(2)
                .background(Color(UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4,x: 3,y: 7)
                

        }
    }
}

public  struct BaseButtonSecondModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        ZStack {
            content
                .padding(4)
                .background(Color.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(2)
                .background(Color(UIColor.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4,x: 3,y: 7)
        }
    }
}


