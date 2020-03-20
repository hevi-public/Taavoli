//
//  GraphController.swift
//  ForceDirectedNew
//
//  Created by Hevi on 13/03/2020.
//  Copyright © 2020 Hevi. All rights reserved.
//

import Foundation
import UIKit

class ImageUIScrollViewController: UIViewController {
    
    var imageView: ImageView! {
        didSet {
            self.scrollView.display(self.imageView)
        }
    }

    private lazy var scrollView: ImageUIScrollView = {
        let view = ImageUIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 5000
        view.contentSize.width = 5000
        view.frame = self.view.frame
        return view
    }()

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

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func display(_ image: UIImage) {
        let imageView = ImageView(image: image)
        self.scrollView.display(imageView)
        
    }
}

