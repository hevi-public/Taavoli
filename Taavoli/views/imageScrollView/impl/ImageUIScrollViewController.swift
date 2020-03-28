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
import Starscream

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
        view.frame = self.view.frame
        return view
    }()
    
    private var timer: Timer? = nil
    
    let webSocketUrl = URL(string: "ws://Hevi-MacBook-Pro.local:8080/drawing")!
    var webSocket: WebSocket!
    
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
        
        webSocket = WebSocket(request: URLRequest(url: webSocketUrl))
        webSocket.delegate = self
        webSocket.connect(maximumLength: 10000000)
 
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func display(_ image: UIImage) {
        
        self.scrollView.display(image)
        
    }
}

extension ImageUIScrollViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
//            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
//            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
            do {
                let drawing = try PKDrawing(data: data)
                let image = drawing.image(from: drawing.bounds, scale: 1.0)
                self.display(image)
            } catch {
                print(error)
            }
            
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
//            isConnected = false
            break
        case .error(let error):
//            isConnected = false
//            handleError(error)
            break
        }
    }
}
