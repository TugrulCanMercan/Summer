//
//  MapLocationTTView.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 11.01.2023.
//

import SwiftUI
import Combine
import MapKit
import UIComponentsPackage


class MapLocationTTViewModel: TTMNavbarViewModel {
    let locationManger = LocationManger.shared
    @Published var searchText: String = ""
    @Published var fetchedPlaces: [CLPlacemark] = []
    @Published var errorMessage = ""
    @Published var currentLocation: CLLocation?
    @Published private(set) var pickedLocation: CLLocation?
    @Published private(set) var pickedPlacemark: CLPlacemark?
    var cancellable = Set<AnyCancellable>()
    
    init() {
        super.init()
        self.observableFunc()
        
    }
    
    func observableFunc() {
        $searchText
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { searchText in
                if !searchText.isEmpty {
                    Task { @MainActor in
                        do {
                            self.fetchedPlaces = try await self.locationManger.fetchPlaces(searchValue: searchText)
                        }catch LocationCustomError.LocationPlacesesError {
                            self.errorMessage = "Konum Bulurken Hata Oluştu"
                        }
                    }
                } else {
                    self.fetchedPlaces = []
                }

            }
            .store(in: &cancellable)
        
        locationManger.$currentLocation
            .removeDuplicates()
            .sink { currentLocation in
                self.currentLocation = currentLocation
        }
            .store(in: &cancellable)
        
        locationManger.$pickedPlacemark
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { place in
            self.pickedPlacemark = place
        }
        .store(in: &cancellable)
        
        locationManger.$pickedLocation.sink { location in
            self.pickedLocation = location
        }
        .store(in: &cancellable)
    }
    func stopUpdateLocation() {
        self.locationManger.stopUpdatingLocation()
    }
    
}


struct MapLocationTTView: View {
    @StateObject var mapLocationTTViewModel = MapLocationTTViewModel()

    var body: some View {
        TTMNavbar(content: {
            TTView(content: {
                VStack {
                    VStack {
                        HStack(spacing: 0) {
                            Image(systemName: "magnifyingglass")

                            TextField("Lütfen Konumu Arayın", text: $mapLocationTTViewModel.searchText)
                                .padding(4)
                        }
                        Rectangle().frame(height:1)
                            .opacity(0.5)

                        Button {
                            mapLocationTTViewModel.appendStack(stackItem: Model(title: "Harita"))
                        } label: {
                            Label {
                                Text("Şuanki Konumu Kullan")
                            } icon: {
                                Image(systemName: "location.north.circle.fill")

                            }
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        }

                    }
                    VStack {
                        if !mapLocationTTViewModel.fetchedPlaces.isEmpty {
                            List {
                                ForEach(mapLocationTTViewModel.fetchedPlaces,id: \.self) { place in
                                    HStack {
                                        HStack(spacing:15) {
                                            Image(systemName: "mappin.circle.fill")
                                                .font(.title2)
                                                .foregroundColor(.gray)
                                        }
                                        VStack {
                                            Text(place.name ?? "")
                                                .font(.title3.bold())
                                            Text(place.locality ?? "")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }

                                }
                            }
                            .listStyle(.plain)
                        }
                    }
                }
            },popUpContent: {
                Text("Hata Mesajı")
            }, showActivate: .constant(false))
                .destionationNavBar { (val:Model) in
                    ExtractedView(mapLocationTTViewModel: mapLocationTTViewModel)

                    
                }
                .navigationTitle("Arama")
                .frame(maxHeight: .infinity,alignment: .top)
                .padding()
                .onDisappear {
                    mapLocationTTViewModel.stopUpdateLocation()
                    if let currentCoordinate = mapLocationTTViewModel.currentLocation {
                        mapLocationTTViewModel.locationManger.mapView.region = .init(center: currentCoordinate.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapLocationTTViewModel.locationManger.addDraggablePin(coordinate: currentCoordinate.coordinate)
                    }
                }

        }, ttMNavbarViewModel: mapLocationTTViewModel)
        

    }
}

struct BottomConfirmationHeight: PreferenceKey {
    static var defaultValue: Double = .zero
    
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}


struct MapLocationTTView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MapLocationTTView()
            
        }
    }
}


struct MapViewHelper: UIViewRepresentable {
    @EnvironmentObject var locationManager: MapLocationTTViewModel
    
    func makeUIView(context: Context) -> some MKMapView {
        return locationManager.locationManger.mapView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct ExtractedView: View {
    @ObservedObject var mapLocationTTViewModel: MapLocationTTViewModel
    @State var showCurrentPin = false
    @State var showConfirmationView = false
    @State var height: Double = .zero
    @State var showQrCodeSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    init(mapLocationTTViewModel: MapLocationTTViewModel) {
        self._mapLocationTTViewModel = .init(wrappedValue: mapLocationTTViewModel)
    }
    var body: some View {
        ZStack {
            GeometryReader { newproxy in
                MapViewHelper()
                    .ignoresSafeArea()
                    .environmentObject(mapLocationTTViewModel)
                
                VStack {
                    if showCurrentPin {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .position(x:newproxy.frame(in:.local).midX,y: newproxy.frame(in:.local).midY)
                        
                    }
                }
                .animation(Animation.easeInOut(duration: 0.3), value: showCurrentPin)

                Button {
                    mapLocationTTViewModel.locationManger.currentLocationGetReuqest()
                    
                    if let currentCoordinate = mapLocationTTViewModel.currentLocation {
                        
                        mapLocationTTViewModel.locationManger.currentLocation(currentCoordinate: currentCoordinate)
                        showCurrentPin = true
                        mapLocationTTViewModel.locationManger.updatePlacemark(location: .init(latitude: currentCoordinate.coordinate.latitude, longitude: currentCoordinate.coordinate.longitude))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            self.showCurrentPin = false
                        })
                    }
                    
                } label: {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 50,height: 50)
                    
                        .foregroundColor(.cyan)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topTrailing)
                .padding()
                
                if let place = mapLocationTTViewModel.pickedPlacemark {
                    
                    VStack(spacing: 15) {
                        Text("Konum Bilgileri")
                            .font(.title2.bold())
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                        HStack(spacing: 15) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title2)
                                .foregroundColor(.gray)
                            VStack {
                                Text(place.name ?? "")
                                    .font(.title3.bold())
                                Text(place.locality ?? "")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            
                            Button {
                                showQrCodeSheet = true
                            } label: {
                                Image(systemName: "qrcode.viewfinder")
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.cyan)
                            }

                            
                        }
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .padding(.vertical,10)
                        
                        Button {
                            showConfirmationView = false
                        } label: {
                            Text("Konumu Seç")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical,12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(.green)
                                }
                                .overlay(alignment:.trailing) {
                                    Image(systemName: "arrow.right")
                                        .font(.title3.bold())
                                        .padding(.trailing)
                                }
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10,style: .continuous)
                            .fill(colorScheme == .dark ? Color.white : .black)
                            .overlay {
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: BottomConfirmationHeight.self, value: proxy.size.height)
                                    
                                }
                            }
                            .onPreferenceChange(BottomConfirmationHeight.self, perform: { value in
                                height = value
                            })
                    }
                    .position(x:newproxy.frame(in: .global).midX,y:newproxy.frame(in: .global).maxY)
                    .ignoresSafeArea()
                    .offset(y: showConfirmationView == true ? -height : height)
                    .onReceive(mapLocationTTViewModel.$pickedPlacemark, perform: { _ in
                        self.showConfirmationView = true
                    })
                    .animation(Animation.easeInOut(duration: 0.5), value: showConfirmationView)
                    
                }
                
                
                
            }
        }
        .sheet(isPresented: $showQrCodeSheet, content: {
            VStack {
                Text("dsadsa")
                CameraScreen()
            }
            
        })
        .onDisappear {
            mapLocationTTViewModel.locationManger.clearAllPickedPlacemarkPickedLocation()
            mapLocationTTViewModel.locationManger.mapviewRemoveAllNotations()
        }
    }
}
