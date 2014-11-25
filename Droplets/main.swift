//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//

import Cocoa

// Setup Application
let application = NSApplication.sharedApplication()
application.setActivationPolicy(NSApplicationActivationPolicy.Regular)

// Create window
let window = NSWindow(contentRect: NSMakeRect(0, 0, 800, 600), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask, backing: .Buffered, defer: false)
window.center()
window.title = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as String?
window.makeKeyAndOrderFront(window)

// Setup Window Delegate
let windowDelegate = WindowDelegate()
window.delegate = windowDelegate

// Setup Application Delegate
let applicationDelegate = ApplicationDelegate(window: window)
application.delegate = applicationDelegate
application.activateIgnoringOtherApps(true)
application.run()
