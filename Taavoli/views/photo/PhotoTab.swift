//
//  PhotoTab.swift
//  Taavoli
//
//  Created by Hevi on 18/03/2020.
//

import SwiftUI

struct PhotoTab: View {
    @EnvironmentObject var environment: Environment
    
    var body: some View {
        ImagePickerController()
    }
}

struct PhotoTab_Previews: PreviewProvider {
    static var previews: some View {
        PhotoTab()
    }
}

struct ImagePickerController : UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @EnvironmentObject var environment: Environment
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerController>) -> UIImagePickerController {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerController>) {
        
    }
}

extension ImagePickerController: UIImagePickerControllerDelegate {
    
}
