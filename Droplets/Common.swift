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
    
    class func selectFile() {
        let myFiledialog:NSOpenPanel = NSOpenPanel()
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.runModal()
        var chosenfile = myFiledialog.URL // holds path to selected file, if there is one
        
        if (chosenfile != nil) {
            // do something with it
            println(chosenfile);
        }
    }
    
}
