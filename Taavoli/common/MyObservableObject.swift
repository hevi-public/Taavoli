//
//  MyObservableObject.swift
//  Taavoli
//
//  Created by Hevi on 20/03/2020.
//

import Foundation
import UIKit

class MyObservableObject: ObservableObject {
    
    public static let instance = MyObservableObject()
    
    @Published var image: UIImage?
}
