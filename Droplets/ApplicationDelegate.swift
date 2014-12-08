//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//

import Foundation
import Cocoa
import WebKit

let DIGITAL_OCEAN_TOKEN = "DigitalOceanToken";

class ApplicationDelegate: NSObject, NSApplicationDelegate {
    
    private var _window: NSWindow;
    
    private var _webServer: LocalServer?;
    
    private(set) var webView : WKWebView?;
    
    private let PORT:UInt = 9066;
    
    init(window: NSWindow) {
        self._window = window
    }
    
    func applicationDidFinishLaunching(notification: NSNotification?) {
        self.setupDefaults();
        
        self.setupMenu();
        
        self.setupWebview();    
    }
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
        self._webServer!.stop();
    }
    
    /**
     * Register default settings
     */
    func setupDefaults() {
        let defaults: Dictionary<NSString,AnyObject> = [
            DIGITAL_OCEAN_TOKEN: ""
        ]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    }

    func setupMenu() {
        var tree = [
            "Edit": [
                NSMenuItem(title: "Copy", action: "copy:", keyEquivalent:"c"),
                NSMenuItem(title: "Paste", action: "paste:", keyEquivalent:"v")
            ],
            "Apple": [
                NSMenuItem(title: "About", action: "orderFrontStandardAboutPanel:", keyEquivalent:""),
                NSMenuItem.separatorItem(),
                NSMenuItem(title: "Quit",  action: "terminate:", keyEquivalent:"q"),
            ],
        ];
        
        let mainMenu = NSMenu(title: "AMainMenu")
        for (title, items) in tree {
            let item = mainMenu.addItemWithTitle(title, action: nil, keyEquivalent:"")
            let menu = NSMenu(title: title)
            mainMenu.setSubmenu(menu, forItem: item!)
            for item in items {
                menu.addItem(item)
            }
        }
        NSApplication.sharedApplication().mainMenu = mainMenu
    }

    func setupServer() {
        let path = NSBundle.mainBundle().resourcePath! + "/Web/Client/";
        self._webServer = NodeServer();
        self._webServer!.start(path, port:PORT);
    }
    
    func setupWebview() {
        var config = WKWebViewConfiguration()
        var webPrefs = WKPreferences()
        
        webPrefs.javaEnabled = false
        webPrefs.plugInsEnabled = false
        webPrefs.javaScriptEnabled = true

        config.preferences = webPrefs
        
        // Setup content controller
        var contentController = WKUserContentController();
        contentController.addScriptMessageHandler(
            MyHandler(),
            name: "callbackHandler"
        );
        config.userContentController = contentController;
        
        // Create webview
        // http://practicalswift.com/2014/06/27/a-minimal-webkit-browser-in-30-lines-of-swift/
        
        let webView = WKWebView(frame: self._window.contentView.frame,
            configuration: config)
        self._window.contentView.addSubview(webView)
        webView.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable // Make resizable
        
        // Load spash screen
        var path =  NSBundle.mainBundle().pathForResource("splash", ofType: "html",
            inDirectory: "Web/client/static")!;
        var splashUrl = NSURL(fileURLWithPath: path);
        webView.loadRequest(NSURLRequest(URL: splashUrl!));
        
        // Start server
        self.setupServer();

        // Load content
        Timer.start(0.7, repeats: false) {
            (t: NSTimer) in
            
            var url = NSURL(string: "http://localhost:\(self.PORT)/index.html");
            var request = NSURLRequest(URL: url!)
            webView.loadRequest(request);
            self.webView = webView;
        }
        
        self.webView = webView;
    }
}
