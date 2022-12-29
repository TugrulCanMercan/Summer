//
//  TTImagePicker.swift
//  TTComponents
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 5.06.2022.
//

import SwiftUI

public struct TTImagePicker: View {
    
    @Binding var image:UIImage?
    
    public init(image:Binding<UIImage?>) {
        self._image = image
    }
    
    
    public var body: some View {
        VStack{
            ImagePicker(image: $image)
        }
    }
}

//struct TTImagePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        TTImagePicker()
//    }
//}



struct ImagePicker:UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    
    @Binding var image:UIImage?
    
    private let imagePickerViewController = UIImagePickerController()
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        imagePickerViewController.delegate = context.coordinator
        return imagePickerViewController
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator:NSObject,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            parent.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    
}
