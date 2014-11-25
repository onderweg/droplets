//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//

import Foundation
import Cocoa

class WindowDelegate: NSObject, NSWindowDelegate {
    
    func windowWillClose(notification: NSNotification?) {
        NSApplication.sharedApplication().terminate(0)
    }
    
}