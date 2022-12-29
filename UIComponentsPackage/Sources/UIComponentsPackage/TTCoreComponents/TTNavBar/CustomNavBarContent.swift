//
//  CustomNavBarContent.swift
//  BitirmeProjesi
//
//  Created by Tuğrulcan on 8.04.2022.
//

import SwiftUI

public struct CustomNavBarContent: View {
    
    @Environment(\.presentationMode) var presentationMode
    let showBackButton: Bool
    let title: String
    let subtitle: String?
    let navBarColor : Color?
    let showRightItem: Bool
    let rightAndLeftItemWidth:CGFloat = 30
    
    public var body: some View {
        
        HStack {
            

            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                
                
                ZStack{
                    if (showBackButton){
                        Image(systemName: "arrow.left")
                    }
                }
                .frame(width:rightAndLeftItemWidth)
            }

            Spacer()
            titleSection
                .frame(maxWidth:.infinity)
            Spacer()
            Button {
                
            } label: {
                
                
                ZStack{
                    if (showRightItem){
                        

                    }
                }
                .frame(width:rightAndLeftItemWidth)
            }

              
            
          
        }
        .padding()
        .accentColor(.white)
        .foregroundColor(.white)
        .font(.headline)
        .background(
            navBarColor.ignoresSafeArea(edges: .top)
        )
    }
    
    func putToContent(string:String) -> some View {
        VStack{
            Text(string)
        }
    }
}

struct CustomNavBarContent_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CustomNavBarContent(showBackButton: true, title: "TItle here", subtitle: "Subtitle goes here", navBarColor: .blue, showRightItem: false)
            Spacer()
        }
    }
}


extension CustomNavBarContent {
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
        })
    }
    
    private var rightButton: some View {
        TTButton(text: "sağ", clicked: {
            print("dsa")
        }, color: .red)
    }
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
    
}
