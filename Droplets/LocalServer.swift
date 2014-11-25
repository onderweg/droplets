//
//  Droplets
//
//  Copyright (c) 2014 Onderweg (http://www.gerwert.io)
//
import Foundation

protocol LocalServer {
    
    func start(localPath: String, port: UInt);
    
    func stop();
}

class NodeServer: LocalServer {
    
    private var task:NSTask?;
    
    init() {
    
    }

    func start(localPath: String, port: UInt) {
        // Create task to start NodeJS server
        let task : NSTask = NSTask();
        let serverPath = NSBundle.mainBundle().resourcePath! + "/Web/server/server.js";
        
        task.launchPath = "/usr/local/bin/node"
        task.arguments = [serverPath, String(port)];
        
        let pipe = NSPipe()
        task.standardOutput = pipe;
        
        task.terminationHandler = { task in
            if task.terminationStatus == EXIT_SUCCESS {
                
            } else {
                // error
            }

        };
        
        task.launch();
        NSLog("Server started, port: \(port)")
        self.task = task;

    }
    
    func stop() {
        task!.terminate();
        NSLog("Local server stopped")
    }

}
