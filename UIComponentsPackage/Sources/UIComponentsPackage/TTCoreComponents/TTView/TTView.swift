//
//  TTErrorableView.swift
//  TTComponents
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 22.04.2022.
//

import SwiftUI

public struct TTView<Content:View,PopUp:View>: View {
    
    let content:Content
    let popUpContent:PopUp?
    
//    @State var degre:CGFloat = .zero
    @Binding var showActivate : Bool
    
    public init(@ViewBuilder content: () -> Content,
         @ViewBuilder popUpContent: () -> PopUp? = {nil},
         
         showActivate:Binding<Bool>
    
    ){
        
       
        self.content = content()
        self.popUpContent = popUpContent()
        self._showActivate = showActivate
        
      
       
    }
    public var body: some View {
        ZStack(alignment:.center){
        
            content
                .blur(radius: showActivate ? 2.0 : 0)
 
            
                if showActivate {
                    Color.black.opacity(0.5)
                    
                    if let popUpContent = popUpContent {
                        popUpContent
                        
//                            .rotationEffect(.degrees(degre))
//                            .animation(.interpolatingSpring(stiffness: 5, damping: 2).speed(2),value: degre)
//                            .onAppear(perform: {
//                                withAnimation(.easeInOut(duration: 2)) {
//                                    degre = 45
//                                }
//                                withAnimation {
//                                    degre = .zero
//                                }
//                                
//                              
//                            })

                            
//                            .transition(.scale)
    
                    }
                    
                    
                    
                 
                }
            
            
         
            
            
        }
        .animation(.easeInOut, value: showActivate)
   
//        .ignoresSafeArea()
      
    }
    
   
}

extension View {
    @ViewBuilder func ifLet<Value, Content: View>(
        _ value: Value?,
        @ViewBuilder then modifySelfWithValue: (Self, Value) -> Content
    ) -> some View {
        if value != nil {
            modifySelfWithValue(self, value!)
        } else { self }
    }
}


struct TTErrorableView_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        
        TTView(content: {
            VStack{
                Text("deneme")
                Text("deneme")
                Text("deneme")
            }
        }, popUpContent: {
            VStack{
                Text("deneme")
                Text("deneme")
                Text("deneme")
            }
        }, showActivate: $show)
        
  
    }
}
