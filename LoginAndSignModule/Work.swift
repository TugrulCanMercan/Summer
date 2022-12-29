//
//  Work.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 28.12.2022.
//

import SwiftUI


//struct Bicycle: View {
//    var body: some View {
//        VStack{
//            HStack(spacing:0){
//
//                HeadShape()
//                    .stroke()
//                    .stroke(lineWidth: 2)
//                    .fill(Color.red)
//
//                    .overlay {
//                        VStack {
//                            Ellipse()
//
//                            HStack{
//                                Circle()
//                                    .stroke()
//                                    .overlay {
//                                        Circle()
//                                            .frame(height: 10)
//                                            .offset(x:10,y:-8)
//                                    }
//                                Circle()
//                                    .stroke()
//                                    .overlay {
//                                        Circle()
//                                            .frame(height: 10)
//                                    }
//                            }
//
//                            Rectangle()
//                                .frame(height: 10)
//                                .frame(width: 100)
//                                .offset(y:30)
//
//
//                            Rectangle()
//                                .frame(height: 10)
//                                .frame(width: 100)
//
//
//
//                        }
//                        .frame(height: 70)
//                    }
//                    .frame(width: 170)
//                    .frame(height: 350)
//            }
//
//
//
//
//
//        }
//
//
//
//    }
//
//}


extension Color {
    static let darkStart = Color("darkstart")
    static let darkEnd = Color("darkend")
}



extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomTrailing)
    }
}




//look 1
 let gradient = AngularGradient(
    gradient: Gradient(colors: [Color.red, Color.pink , Color.yellow , Color.orange , Color.green , Color.blue , Color("indigo") , Color("violet")]),
    center: .center,
    startAngle: .degrees(340),
    endAngle: .degrees(0))

//look 2
let gradient2 = AngularGradient(
   gradient: Gradient(colors: [Color.green, Color.orange , Color.yellow , Color.pink , Color.red ]),
   center: .center,
   startAngle: .degrees(340),
   endAngle: .degrees(0))

//look 3
let gradient3 = AngularGradient(
   gradient: Gradient(colors: [Color.blue, Color("indigo") , Color("violet") , Color.pink , Color.red ]),
   center: .center,
   startAngle: .degrees(340),
   endAngle: .degrees(0))

struct CircularSlider: View {
    
    @State var progress : CGFloat = 0
    @State var angle : Double = 0
    
    var body: some View{
        
        VStack{
            ZStack{
                
                
                
                ZStack{
                Image("pod2")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .opacity(1)
                    .shadow(color: .blue.opacity(0.2), radius: 5, x: 10, y: 10)
                    .shadow(color: .pink.opacity(0.2), radius: 5, x: -10, y: -10)
                    
                }.rotationEffect(.degrees(180))
                
                
                
                
                
                Circle()
                    .stroke(Color.black ,style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                    .frame(width: 300, height: 300)
                    
                
                ZStack{
                
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round))
                        .frame(width: 300, height: 300)
                        .rotationEffect(.init(degrees: -90))
                        
                    
                    }
                
                
                
                // Drag Circle...
                
               Circle()
                    .fill( LinearGradient(Color.darkStart, Color.darkEnd))
                    .frame(width: 70, height: 70)
                    .overlay {
                        Circle().stroke(.white, lineWidth: 4)
                            }
                    .offset(x: 300 / 2)
                    .rotationEffect(.init(degrees: angle))
                    .shadow(color: .black, radius: 2, x: -5, y: -5)
                
                // adding gesture...
                    .gesture(DragGesture().onChanged(onDrag(value:)))
                    .rotationEffect(.init(degrees: -90))
                
                // 100 %
                
                
                HStack{
                    
                    Image(systemName: "speaker.wave.2")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                    
                    Spacer()
                        .frame(width: 20)
                    
                    
                    Text("V O L U M E")
                       .foregroundColor(.white)
                       .font(.system(size: 20))
                       .fontWeight(.semibold)
               
                    Text(String(format: "%.0f", progress * 100))
                    .foregroundColor(.white)
                    .font(.system(size: 70))
                    .fontWeight(.bold)
                    .frame(width: 130)
                    .padding()
                    
                    Text("%")
                       .foregroundColor(.white)
                       .font(.system(size: 30))
                       .fontWeight(.semibold)
                   
                    
                }.offset(x: 0, y: 250)
                .rotationEffect(.degrees(180))
            }
        }
    }
    
    func onDrag(value: DragGesture.Value){
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 27.5, vector.dx - 27.5)
        var angle = radians * 180 / .pi
        if angle < 0{angle = 360 + angle}
        withAnimation(Animation.linear(duration: 0.15)){
            
            // progress...
            let progress = angle / 360
            self.progress = progress
            self.angle = Double(angle)
        }
    }
}


//struct Noise: View {
//    var body: some View {
//        GeometryReader { proxy in
//            Path { path in
//                path.move(to:.init(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY))
//                path.addArc(center: CGPoint(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY), radius: 20, startAngle: .degrees(0), endAngle: .degrees(30), clockwise: true)
//            }
//        }
//    }
//}

struct NoiseShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to:.init(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 20, startAngle: .degrees(-10), endAngle: .degrees(50), clockwise: true)
        }
    }
    
}

struct HeadShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            path.move(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.midY - rect.width * 0.1))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - rect.width * 0.1, y: rect.midY - rect.width * 0.1) , control: CGPoint(x: rect.midX, y: rect.minY))
            path.addCurve(to: CGPoint(x: rect.minX + rect.width * 0.1, y: rect.midY - rect.width * 0.1), control1: CGPoint(x: rect.maxX - rect.width * 0.3, y: rect.maxY), control2: CGPoint(x: rect.minX + rect.width * 0.3, y: rect.maxY))
            //            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 20, startAngle: .degrees(-10), endAngle: .degrees(50), clockwise: true)
        }
    }
    
}


struct Work_Previews: PreviewProvider {
    static var previews: some View {
        CircularSlider()
    }
}
