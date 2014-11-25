//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//

import Foundation
import WebKit
import Cocoa

class WebMessageHandler: NSObject, WKScriptMessageHandler {
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        let obj: AnyObject = message.body;

        switch obj {
            case let obj as NSNull:
                fatalError("Messsage is not supposed to be null") // should never happen!
            default:
                self.handle(obj);
        }
    }
    
    /**
     * Handles an incomming message from Javascript
     */
    func handle(obj: AnyObject) {
        
        // Inherit from this class, and place your message handling here
        
    }
    
    /**
     * Posts a message back to Javascript
     */
    func respond(obj: AnyObject) {
        let delegate = NSApplication.sharedApplication().delegate as ApplicationDelegate;
        let webView = delegate.webView!;
        let dataStr = self.JSONStringify(obj, prettyPrinted: true);
        let js = "reactor.trigger('message', \(dataStr))";
 
        webView.evaluateJavaScript(js,completionHandler: nil);
    }
    
    /**
     * Convenience response method
     */
    func respond(id: UInt, payload: AnyObject, error: NSError? = nil) {
        var response = [
            "_id": id,
            "payload": payload
        ];
        if (error != nil) {
            response["_error"] = error!.userInfo;
        }
        self.respond( (response as AnyObject)  );
    }
    
    private func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }

}
