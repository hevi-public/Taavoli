//
//  PhotoTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI
import UIKit

struct CaptureImageView: UIViewControllerRepresentable {
    
    
    @Binding var isCameraShown: Bool
    @Binding var isAlbumShown: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isCameraShown: $isCameraShown, isAlbumShown: $isAlbumShown , image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if isCameraShown {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .savedPhotosAlbum
        }
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {
        
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorCameraShown: Bool
    @Binding var isCoordinatorAlbumShown: Bool
    @Binding var imageInCoordinator: Image?
    
    @ObservedObject var observed: MyObservableObject = MyObservableObject.instance
    
    init(isCameraShown: Binding<Bool>, isAlbumShown: Binding<Bool>, image: Binding<Image?>) {
        _isCoordinatorCameraShown = isCameraShown
        _isCoordinatorAlbumShown = isAlbumShown
        _imageInCoordinator = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorCameraShown = false
        isCoordinatorAlbumShown = false
        observed.image = unwrapImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorCameraShown = false
        isCoordinatorAlbumShown = false
    }
}

