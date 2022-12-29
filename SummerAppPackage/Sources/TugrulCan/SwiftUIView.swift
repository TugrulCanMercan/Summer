//
//  SwiftUIView.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 25.12.2022.
//

import SwiftUI


public struct Tolga {
    public var asd: String = "dsadsa"
    public init(asd: String) {
        self.asd = asd
    }
}



public struct SwiftUIView: View {
    public var body: some View {
        VStack {
            Text("Hello, World!")
        } 
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
