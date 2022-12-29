//
//  NavBarRightItem.swift
//  BitirmeProjesi
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 14.04.2022.
//

import SwiftUI

public struct NavBarRightItem<Content:View>: View {
    
    let content : Content
    
    
    public init(@ViewBuilder content: () -> Content){
        self.content = content()
        
    }
    
    
    
    public var body: some View {
        VStack{
            
        }
    }
}

struct NavBarRightItem_Previews: PreviewProvider {
    static var previews: some View {
        NavBarRightItem {
            VStack{
                
            }
        }
    }
}
