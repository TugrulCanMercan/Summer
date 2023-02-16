//
//  TTPicker.swift
//  TTComponents
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 28.04.2022.
//

import SwiftUI


public struct TTPicker<Content:View>: View {
    var backGroundColor:Color = .gray
    
    @Binding var select:String
    let content:Content
    public init(backGroundColor:Color,
         @ViewBuilder content: () -> Content,
         select:Binding<String>
    ){
        self.backGroundColor = backGroundColor
        self._select = select
        self.content = content()
    }
    
    public var body: some View {
        VStack{
            VStack{
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 100, height: 32, alignment: .center)
                        .foregroundColor(.cyan)
                    
                    
                    Picker(select, selection: $select) {

                        content
                        
                    }
               
                    .pickerStyle(.wheel)
                    
                    .compositingGroup()
                
                    
                    
                }
                
               
           
            
            }
            .frame(width:UIScreen.main.bounds.width / 1.5)
            .scaledToFit()
          
            .background(backGroundColor)
//            .clipped(antialiased: true)
            .cornerRadius(10)
            
            
            
        }
    }
}

struct TTPicker_Previews: PreviewProvider {
    static var previews: some View {
        TTPicker(backGroundColor: .red, content: {
            VStack{
                ForEach(1...3,id:\.self) { _ in
                    Text("dsadsa")
                }
            }
        }, select: .constant("tugrul"))
    }
}
