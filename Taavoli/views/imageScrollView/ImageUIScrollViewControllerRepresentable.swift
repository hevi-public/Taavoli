//
//  ImageUIScrollViewSwiftUI.swift
//  Taavoli
//
//  Created by Hevi on 20/03/2020.
//

import Foundation
import SwiftUI

struct ImageUIScrollViewControllerRepresentable: UIViewControllerRepresentable {
    
    @ObservedObject var observed: MyObservableObject = MyObservableObject.instance
    
    typealias UIViewControllerType = ImageUIScrollViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageUIScrollViewControllerRepresentable>) -> ImageUIScrollViewController {
        ImageUIScrollViewController()
    }
    
    func updateUIViewController(_ uiViewController: ImageUIScrollViewController, context: UIViewControllerRepresentableContext<ImageUIScrollViewControllerRepresentable>) {
        guard let image = observed.image else { return }
        uiViewController.display(image)
    }
}
