//
//  TTPopUp.swift
//  TTComponents
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 28.04.2022.
//

import SwiftUI

public struct TTPopUp: View {
    
    @Binding var push:Bool
    let errorMessage:String
    let errorImageName:String
    @State var degre:CGFloat = .zero
    public init(
        push:Binding<Bool>,
        errorMessage:String,
        errorImageName:String
    ){
        self._push = push
        self.errorMessage = errorMessage
        self.errorImageName = errorImageName
    }
    
    
    public var body: some View {
        VStack{
            GeometryReader{geo in
                RoundedRectangle(cornerRadius: 15)
                
                    .fill(Color.yellow)
                    
                    .frame(width: geo.size.width/1.5, height: geo.size.height/3)
                    .position(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                    .overlay {
                        VStack{
                            Text(errorMessage)
                            
                            Image(systemName: errorImageName)
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 75, height:75, alignment: .center)
                            
                            
                        }
 
                    }
                    .rotationEffect(.degrees(degre))
                    .animation(.interpolatingSpring(stiffness: 5, damping: 2).speed(2),value: degre)
                    .onAppear(perform: {
                        withAnimation(.easeInOut(duration: 2)) {
                            degre = 45
                        }
                        withAnimation {
                            degre = .zero
                        }
                        
                      
                    })
                  
                
                
                    .onTapGesture {
                        push.toggle()
                    }
                
                
                
                
            }
            
            
        }
    }
}

struct TTPopUp_Previews: PreviewProvider {
    static var previews: some View {
        TTPopUp(push: .constant(true), errorMessage: "tugrul", errorImageName: "naber")
    }
}
