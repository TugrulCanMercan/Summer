//
//  CustomNavBarPreference.swift
//  BitirmeProjesi
//
//  Created by Tuğrulcan on 8.04.2022.
//

import SwiftUI

struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
}

struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
    
}

struct CustomNavBarBackButtonHiddenPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
    
}

struct CustomNavigationBarColorPreferenceKey: PreferenceKey {
    
    static var defaultValue: Color = .clear
    
    static func reduce(value: inout  Color, nextValue: () ->  Color) {
        value = nextValue()
    }
    
}

struct CustomNavigationBarRightItemPreferenceKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout  Bool, nextValue: () ->  Bool) {
        value = nextValue()
    }
    
}



extension View {
    
   
        
    public func customNavigationTitle(_ title: String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }

    public func customNavigationSubtitle(_ subtitle: String?) -> some View {
        preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
    }
    
    public func customNavigationBarBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self, value: hidden)
    }
    public func customNavigationBarColor(_ color: Color) -> some View {
        preference(key: CustomNavigationBarColorPreferenceKey.self, value: color)
    }

    public func custonNavigationShowRightItem(_ hidden: Bool) -> some View {
        preference(key: CustomNavigationBarRightItemPreferenceKey.self, value: hidden)
    }
    
    
    public func customNavBarItems<Content:View>(title: String = "", subtitle: String? = nil, backButtonHidden: Bool = false,color:Color,rightItemShow:Bool ,@ViewBuilder deneme: () -> Content ) -> some View {
        self
            .customNavigationBarColor(color)
            .customNavigationTitle(title)
            .customNavigationSubtitle(subtitle)
            .customNavigationBarBackButtonHidden(backButtonHidden)
            .custonNavigationShowRightItem(rightItemShow)
            
    }
    
}
