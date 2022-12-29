//
//  PromotionBar.swift
//  BitirmeProjesi
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 9.04.2022.
//

import SwiftUI

struct NewPin:Identifiable {
    var id: Int
    
    let name:String
    var color:Color
}
struct Pin:Hashable{
    let name:String
    var color:Color
    let progresPercent:Double
    let subTitle:String
    
}
public struct TTPromotionBar: View {
    @State var percent:CGFloat = 0.50
    @State var color:Color = .gray
    @State var pinList:[Pin] = [Pin(name: "drop.fill", color: .gray, progresPercent: 0, subTitle: "İlk Ay")
                                ,Pin(name: "drop.fill", color: .gray, progresPercent: 0.25, subTitle: "3.Ay")
                                ,Pin(name: "drop.fill", color: .gray, progresPercent: 0.50, subTitle: "6.Ay")
                                ,Pin(name: "drop.fill", color: .gray, progresPercent: 0.75, subTitle: "9.Ay"),
                                Pin(name: "drop.fill", color: .gray, progresPercent: 1, subTitle: "TERFİ")]
    
    public init(){ }
    
    public var body: some View {
        ZStack(alignment: .leading){
            
            ZStack(alignment:.trailing ){
                Capsule().fill(.black.opacity(0.08)).frame(height: 22)
                
                
            }
            
            Capsule()
                .fill(.red)
                .frame(width: self.callPercent(), height: 22)
            HStack{
                
                ForEach(pinList, id: \.self) { idx in
                    
                   
                    ZStack{
                        Image(systemName: idx.name)
                            .foregroundColor(idx.progresPercent <= percent ? .green : .blue)
                        
                            .rotationEffect(.degrees(180))
                            .scaleEffect(idx.progresPercent == percent ? 2 : 1 )
                       
                        
                        if pinList.last != idx {
                            Spacer()
                        }
                        Text(idx.subTitle)
                            .font(.caption)
                            .offset(x: 0, y: 20)
                    }
                    .frame(maxWidth: .infinity)
                    
  
     
                }

            }.frame(maxWidth: .infinity,alignment: .leading)
            
            
            
            
            
            
        }
        .padding(18)
        .background(Color.black.opacity(0.085))
        .cornerRadius(15)
    }
    
    func callPercent()->CGFloat{
        let width =  UIScreen.main.bounds.width - 36
        return width * self.percent
    }
}

struct PromotionBar_Previews: PreviewProvider {
    static var previews: some View {
        TTPromotionBar()
    }
}


