//
//  AlbumTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct AlbumTab: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    
    func makeCoordinator() -> AlbumCoordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlbumTab>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .savedPhotosAlbum
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<AlbumTab>) {
        
    }
}

class AlbumCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInCoordinator = Image(uiImage: unwrapImage)
        print(unwrapImage.size)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
