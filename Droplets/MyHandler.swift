//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//

import Foundation

class MyHandler : WebMessageHandler {
    
    private var api: DigitalOcean;
    
    private var myContext = 0;
    
    override init () {
        let bearer = NSUserDefaults.standardUserDefaults().stringForKey("DigitalOceanToken")!;
        self.api = DigitalOcean(token:bearer);
        super.init();
        
        NSUserDefaults.standardUserDefaults().addObserver(self, forKeyPath: "DigitalOceanToken", options: .New, context: &myContext);
    }
    
    /**
    * If token value changes (e.g. via Settings screen), set new token in API object
    */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if (keyPath == "DigitalOceanToken") {
                var newVal: AnyObject? = change[NSKeyValueChangeNewKey];
                if (newVal != nil) {
                    self.api.setToken( newVal! as String);
                } else {
                    self.api.setToken( "");
                }
            }
            println("Changed: \(change[NSKeyValueChangeNewKey])")
        }
    }
    
    override func handle(obj: AnyObject) {
        assert ((obj is NSDictionary), "Data must be of type NSDictionary");
        
        var data = obj as NSDictionary
        var id = data["_id"] as UInt
        var message = data["message"] as String;
        
        if (message == "get-list") {
            self.api.getDroplets() {
                (droplets: NSDictionary, err: NSError?) -> Void in
                self.respond(id, payload: droplets, error: err);
            };
        } else if (message == "power-on") {
            var dropletId = data["dropletId"] as NSInteger;
            self.api.powerOn(dropletId);
        } else if (message == "get-config") {
            var dict = NSUserDefaults.standardUserDefaults().dictionaryRepresentation();
            self.respond(id, payload: dict);
        } else if (message == "set-config-value") {
            var params = data["params"] as NSDictionary;
            NSUserDefaults.standardUserDefaults().setValue(params["value"] as String, forKey: params["key"] as String);
        } else if (message == "confirm") {
            var text = data["text"] as String;
            var b = DialogPresenter.confirm(text)
            self.respond(id, payload: b);
        }
    }
    
}
