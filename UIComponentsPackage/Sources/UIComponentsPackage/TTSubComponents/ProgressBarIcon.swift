//
//  ProgressBarIcon.swift
//  BitirmeProjesi
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 13.04.2022.
//

import SwiftUI

public struct ProgressBarIcon: View {
    
    
    public var body: some View {
        VStack{

                
            CustomIcon()
                
                

                
            
        }
        
    }
}

struct ProgressBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarIcon()
    }
}



struct CustomIcon : Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 150, startAngle: .degrees(0), endAngle: .degrees(180), clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
    
}
