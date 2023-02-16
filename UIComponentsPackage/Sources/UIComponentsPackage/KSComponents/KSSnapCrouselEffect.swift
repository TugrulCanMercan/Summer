//
//  KSSnapCrouselEffect.swift
//  TTComponents
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 13.05.2022.
//

import SwiftUI


public struct KSSnapCrouselEffect<Content:View,T:Identifiable>: View {
    var content:(T) -> Content
    var list:[T]
    var spacing:CGFloat
    var trailingSpace:CGFloat
    @Binding var index:Int
    public init(
        spacing:CGFloat = 15,
        trailingSpace:CGFloat = 100,
        index:Binding<Int>,
        items:[T],
        @ViewBuilder content: @escaping (T) -> Content
        
    ){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset : CGFloat = 0
    @State var currentIndex : Int = 0
    public var body: some View {
        GeometryReader{proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            HStack(spacing:spacing){
                ForEach(list){item in
                    
                    content(item)
                        .frame(width:proxy.size.width - trailingSpace)
                    
                }
            }
            .padding(.horizontal,spacing)
            .offset(x:(CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundedIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundedIndex), list.count - 1),0)
                        
                        currentIndex = index
                    })
                    .onChanged({value in
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundedIndex = progress.rounded()
                        
                        index = max(min(currentIndex + Int(roundedIndex), list.count - 1),0)
                    })
            )
            
            
        }
        .animation(.easeInOut, value: offset == 0)
    }
}







////****************

struct DemoView:View{
    @State var currentIndex = 0
    @State var posts:[Post] = []
    var body: some View{
        VStack{

            KSSnapCrouselEffect(spacing:10,trailingSpace:0,index: $currentIndex, items: posts) { post in
                GeometryReader{proxy in
                    let size = proxy.size
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .frame(height:100)
                        .cornerRadius(12)

                }
            }

            .padding(.vertical)
        }
        .frame(maxHeight:.infinity,alignment: .top)
        .onAppear {
            for index in 1...5{
                posts.append(Post(postImage: "Resim\(index)"))
            }
        }
    }
}

struct Post:Identifiable{
    var id =  UUID().uuidString
    var postImage:String
}

struct KSSnapCrouselEffect_Previews: PreviewProvider {
   
    static var previews: some View {
        DemoView()
    }
    
}
