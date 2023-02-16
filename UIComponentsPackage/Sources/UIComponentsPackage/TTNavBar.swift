//
//  SwiftUIView.swift
//  
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 23.12.2022.
//

import SwiftUI


open class TTMNavbarViewModel:NavigationStackDestinationDatasource<Model>, ObservableObject {
    @Published var navbartitle: String = ""
    @Published var rightToolButtonVM: TTMButtonViewModel?
    @Published var leftToolButtonVM: TTMButtonViewModel?
    
    public init(navbartitle: String = ""
         ) {
        self.navbartitle = navbartitle
    }

    public override func getItem(stackId: String) -> Model? {
//        configrationResend(stackId: stackId)
        return navigationStack.first(where: {$0.id == stackId})
    }
    
    public override func configrationResend(stackId: String) {

    }

}


open class NavigationStackDestinationDatasource<T:NavigationStackItem> {
    @Published var navigationStack:[T] = []
    
    
    public func appendStack(stackItem: T) {
        navigationStack.append(stackItem)
        
    }
    
    public func getItem(stackId: String) -> T? {
        navigationStack.first(where: {$0.id == stackId})
    }
    public func configrationResend(stackId: String) {}
    
}

protocol NewStack {
    associatedtype T
    func appendStack(stackItem: T)
}


struct NewModel:NavigationStackItem {
    
    static func == (lhs: NewModel, rhs: NewModel) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String = UUID().uuidString
    
    var title: String
    
    var rightToolButtonVM: TTMButtonViewModel?
    
    var leftToolButtonVM: TTMButtonViewModel?
    
    var newProperty: Int
}



public protocol NavigationStackItem: Hashable,Identifiable {
    var id: String {get set}
    var title: String {get set}
    var rightToolButtonVM: TTMButtonViewModel? {get set}
    var leftToolButtonVM: TTMButtonViewModel? {get set}
}

public struct Model: NavigationStackItem {
    public static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
         return hasher.combine(id)
    }
    
    public var rightToolButtonVM: TTMButtonViewModel?
    
    public var leftToolButtonVM: TTMButtonViewModel?
    
    public var id: String = UUID().uuidString
    
    public var title: String
    
    public init(rightToolButtonVM: TTMButtonViewModel? = nil, leftToolButtonVM: TTMButtonViewModel? = nil, id: String = UUID().uuidString, title: String) {
        self.rightToolButtonVM = rightToolButtonVM
        self.leftToolButtonVM = leftToolButtonVM
        self.id = id
        self.title = title
    }
    
    
}

public struct TTMNavbar<Content:View>: View {
    
    @StateObject var ttMNavbarViewModel: TTMNavbarViewModel
    public let content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content, ttMNavbarViewModel:TTMNavbarViewModel) {
        self.content = content()
        self._ttMNavbarViewModel = .init(wrappedValue: ttMNavbarViewModel)
    }
    
    public var body: some View {
        NavigationView {
            NavigationStack(path: $ttMNavbarViewModel.navigationStack) {
                VStack {
                    content
                }
                .toolbar {
                    if let rightToolButtonVM = ttMNavbarViewModel.rightToolButtonVM {
                        ToolbarItem(placement: .navigationBarLeading) {
                            TTMButton(ttMButtonViewModel: rightToolButtonVM)
                        }
                    }
                    if let leftToolButtonVM = ttMNavbarViewModel.leftToolButtonVM {
                        ToolbarItem {
                            TTMButton(ttMButtonViewModel: leftToolButtonVM)
                        }
                    }
                }

//                .navigationBarTitle(Text(ttMNavbarViewModel.navbartitle)
//                    .font(.system(size: 20))
//                    .fontWeight(.bold))
                .navigationBarTitle (Text(ttMNavbarViewModel.navbartitle), displayMode: .inline)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.red, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarBackButtonHidden(false)

            }
        }
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var vm =  TTMNavbarViewModel(navbartitle: "das")
    static var previews: some View {
        TTMNavbar(content: {
            VStack {
                Button("dsa") {
                    let asd = TTMButtonViewModel()
                    asd.buttonTitle = "deneme111"
                    vm.navigationStack.append(Model(rightToolButtonVM: asd, title: "Selam"))

                }
            }
            
            .destionationNavBar(hadler: { (val:Model) in

                VStack{
                    let item = vm.getItem(stackId: val.id)
                    Button("dsa\(item?.title ?? "")") {
                        vm.navigationStack.append(Model(title: "rfdsfds"))
                    }
                    Button(val.title) {
                        vm.navigationStack.removeAll()
                    }
                }
            })
            
        }, ttMNavbarViewModel: vm)
    }
}

extension View {
    
    @ViewBuilder
    public func destionationNavBar<T:NavigationStackItem,U:View>(hadler: @escaping ((T) -> U)) -> some View {
        navigationDestination(for: T.self) { value in
                hadler(value)
                .toolbar {
                    if let rightToolButtonVM = value.rightToolButtonVM {
                        ToolbarItem(placement: .navigationBarLeading) {
                            TTMButton(ttMButtonViewModel: rightToolButtonVM)
                        }
                    }
                    if let leftToolButtonVM = value.leftToolButtonVM {
                        ToolbarItem {
                            TTMButton(ttMButtonViewModel: leftToolButtonVM)
                        }
                    }
                }

                .navigationTitle(value.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.red, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}
