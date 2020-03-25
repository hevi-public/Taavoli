//
//  GraphController.swift
//  ForceDirectedNew
//
//  Created by Hevi on 13/03/2020.
//  Copyright © 2020 Hevi. All rights reserved.
//

import Foundation
import UIKit
import PencilKit

class ImageUIScrollViewController: UIViewController {
    
    var imageView: ImageView! {
        didSet {
            if let image = self.imageView.image {
                self.scrollView.display(image)
            }
        }
    }
    
    private lazy var scrollView: ImageUIScrollView = {
        let view = ImageUIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 50000
        view.contentSize.width = 50000
        
        view.frame = self.view.frame
        return view
    }()
    
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        print("GraphController viewDidLoad")
        
        self.view.addSubview(scrollView)
        self.view.backgroundColor = .black
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        scrollView.setup()
        
        self.view.isMultipleTouchEnabled = true
        //        self.imageView.isMultipleTouchEnabled = true
        
        
        self.createUpdater()
        
        
    }
    
    
    private func createUpdater() {
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
            
            
            
            let url = URL(string: "http://Hevi-MacBook-Pro.local:8080")!
            var request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                
               
                
                
                
                
                
                
                if let responseJSON = try? JSONDecoder().decode([DrawingRequest].self, from: data) {
                
                    //                    print("ResponseJSON: " + responseJSON.description)
                    
                    let last = responseJSON.last
                    if let drawingData = last?.drawingData {
                                
                        DispatchQueue.main.async {
                            do {
                                let drawing = try PKDrawing(data: drawingData)
                                let image = drawing.image(from: drawing.bounds, scale: 1.0)
                                self.display(image)
                            } catch {
                                print("error converting to pkdrawing")
                            }
                        }
                        
                    }
                }
            }
            
            task.resume()
            
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func display(_ image: UIImage) {
        
        self.scrollView.display(image)
        
    }
}

