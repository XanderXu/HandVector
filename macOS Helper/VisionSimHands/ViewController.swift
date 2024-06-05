//
//  ViewController.swift
//  VisionSimHands
//
//  Created by Ben Harraway on 15/12/2023.
//

import Cocoa
import WebKit
import Bonjour

class ViewController: NSViewController, WKUIDelegate, WKScriptMessageHandler {
    
    let bonjour = BonjourSession(configuration: .default)
    var webView: WKWebView!

    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callback")
        
        let webConfiguration = WKWebViewConfiguration ()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webConfiguration.userContentController = contentController
        
        webView = WKWebView (frame: CGRect(x:0, y:0, width:800, height:600), configuration:webConfiguration)
        webView.uiDelegate = self
        
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .init(red: 255.0, green: 0.0, blue: 0.0, alpha: 1.0)

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        webView.loadFileURL(Bundle.main.url(forResource: "index", withExtension: "html")!, allowingReadAccessTo: Bundle.main.bundleURL)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // Data incoming from WKWebView...
        guard let response = message.body as? String else { return }
        
        if (response == "start_server") {
            bonjour.start()
            bonjour.onPeerConnection = { peer in
                print("Hello peer", peer)
            }
            bonjour.onPeerLoss = { peer in
                print("Lost peer", peer)
            }
            bonjour.onPeerDisconnection = { peer in
                print("Disconnected peer", peer)
            }
            
        } else if (response == "stop_server") {
            bonjour.stop()
            
        } else if let data = response.data(using: .utf8) {
            bonjour.broadcast(data)
        }
      }
}

