//
//  CameraScreen.swift
//  LoginAndSignModule
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.01.2023.
//

import SwiftUI
import AVFoundation

public struct CameraScreen: View {
    @StateObject var cameraManager: CameraManager
    
    public init(CameraManager: CameraManager = CameraManager(preview: AVCaptureVideoPreviewLayer())) {
        self._cameraManager = .init(wrappedValue: CameraManager)
    }
    
    public var body: some View {
        ZStack {
            CameraPreview(camera: cameraManager)
                .ignoresSafeArea(.all,edges: .all)
        }
        .onAppear {
            cameraManager.checkPermisson()
        }
    }
}

struct CameraScreen_Previews: PreviewProvider {
    static var previews: some View {
        CameraScreen()
    }
}

public class CameraManager:NSObject, ObservableObject {
    @Published var isTaken = false
    @Published var isSaved = false
    let session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    var preview: AVCaptureVideoPreviewLayer!
    @Published var pictureData = Data(count: 0)
    let metaDataOutput = AVCaptureMetadataOutput()
    
    public init(isTaken: Bool = false,
                isSaved: Bool = false,
                output: AVCapturePhotoOutput = AVCapturePhotoOutput(),
                preview: AVCaptureVideoPreviewLayer!,
                pictureData: Data = Data(count: 0)) {
        self.isTaken = isTaken
        self.isSaved = isSaved
        self.output = output
        self.preview = preview
        self.pictureData = pictureData
    }
    
    func checkPermisson() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setupCamera()
                    
                    return
                }
            }
        case .restricted:
            return
        case .denied:
            print("Hata pop up patlat")
            return
        case .authorized:
            
            self.setupCamera()
            
            return
        @unknown default:
            return
        }
    }
    
    func setupCamera() {
        do {
            self.session.beginConfiguration()
            guard let videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
            let input = try AVCaptureDeviceInput(device: videoCaptureDevice)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.canAddOutput(self.output)
            }
            
            
            self.session.commitConfiguration()
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func setupQrCamera() {
        do {
            self.session.beginConfiguration()
            guard let device = AVCaptureDevice.default(.builtInDualCamera,for: .video,position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.metaDataOutput){
                self.session.canAddOutput(self.metaDataOutput)
                
                metaDataOutput.setMetadataObjectsDelegate(self, queue: .main)
                metaDataOutput.metadataObjectTypes = [.qr]
            }
            
            
            self.session.commitConfiguration()
            
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func takeAPhoto() {
        
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func reTakeAPhot() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                    self.isSaved = false
                }
            }
        }
    }
    
    func savePicture() {
        guard let image = UIImage(data: self.pictureData) else {return }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.isSaved = true
        
    }

}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
//            Handle Error
            return }
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.pictureData = imageData
    }
}

extension CameraManager: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    func found(code: String) {
        print(code)
    }
}

struct CameraPreview: UIViewRepresentable {
    
    typealias UIViewType = UIView
    
    @ObservedObject var camera: CameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        camera.preview.videoGravity = .resizeAspectFill
        guard let preview = camera.preview else { return UIView() }
        view.layer.addSublayer(preview)
        DispatchQueue.global(qos: .userInteractive).async {
            self.camera.session.startRunning()
        }
        
    
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    
}
