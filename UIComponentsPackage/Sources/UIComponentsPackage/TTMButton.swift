//
//  TTMButton.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.12.2022.
//

import SwiftUI

public class TTMButtonViewModel: ObservableObject {
    @Published var buttonTitle: String = "s"
    @Published var buttonAciton: (() -> Void)?
    @Published var buttonRole: ButtonRole? = nil
    @Published var ttmdefaultModifier: TTButtonTitleModifier?
}

public struct TTMButton: View {
    @ObservedObject var ttMButtonViewModel: TTMButtonViewModel
    
    public var body: some View {
        VStack {
            Button(ttMButtonViewModel.buttonTitle,
                   role: ttMButtonViewModel.buttonRole) {
                ttMButtonViewModel.buttonAciton?()
            }
                   .ttMButtonModifier(modifier: ttMButtonViewModel.ttmdefaultModifier)
        }
    }
}

public struct TTButtonTitleModifier: ViewModifier {
    var title: String
    var alignment: Alignment = .center
    var font: Font? = .caption
    var forgroundColor: Color? = .black
    var backgroundColor: Color?
    var padding: CGFloat = 8
    public func body(content: Content) -> some View {
        ZStack(alignment: alignment) {
            content
            Text(title)
                .font(font)
                .foregroundColor(forgroundColor)
                .padding(padding)
                .background(backgroundColor)
        }
    }
}

public extension View {
    func ttMButtonModifier(title: String) -> some View {
        modifier(TTButtonTitleModifier(title: title))
    }
    func ttMButtonModifier(title: String,
                           alignment: Alignment,
                           font:Font?,
                           forgroundColor:Color?,
                           backgroundColor:Color?,
                           padding:CGFloat) -> some View {
        modifier(TTButtonTitleModifier(title: title,
                                       alignment: alignment,
                                       font: font,
                                       forgroundColor: forgroundColor,
                                       backgroundColor: backgroundColor,
                                       padding: padding))
    }
    @ViewBuilder
    func ttMButtonModifier(modifier: TTButtonTitleModifier?) -> some View  {
        if let modifier = modifier {
            self.modifier(modifier)
        }
    }
}

struct TTMButton_Previews: PreviewProvider {
    static var vm = TTMButtonViewModel()
    static var previews: some View {
        VStack {
            TTMButton(ttMButtonViewModel: TTMButtonViewModel())
        }
        
    }
}
