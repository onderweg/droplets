import Cocoa

class DialogPresenter {
    
    class func showError(errorText: String) {
        let alert = NSAlert()
        alert.messageText = errorText
        alert.addButtonWithTitle("OK")
        
        NSLog(errorText)
        alert.runModal()
    }
    
    class func confirm(text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = text;
        alert.addButtonWithTitle("Yes")
        alert.addButtonWithTitle("No")

        return (alert.runModal() == NSAlertFirstButtonReturn);
    }
    
}

// http://moxsoini.blogspot.nl/2014/09/nstimer-using-swift-and-closures.html
public class Timer {
    // each instance has it's own handler
    private var handler: (timer: NSTimer) -> () = { (timer: NSTimer) in }
    
    public class func start(duration: NSTimeInterval, repeats: Bool, handler:(timer: NSTimer)->()) {
        var t = Timer()
        t.handler = handler
        NSTimer.scheduledTimerWithTimeInterval(duration, target: t, selector: "processHandler:", userInfo: nil, repeats: repeats)
    }
    
    @objc private func processHandler(timer: NSTimer) {
        self.handler(timer: timer)
    }
}
