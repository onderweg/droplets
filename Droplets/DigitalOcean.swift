//
//  RestRequest.swift
//  Webview2
//
//  Created by Gerwert Stevens on 19-11-14.
//  Copyright (c) 2014 Onderweg. All rights reserved.
//

import Foundation

class DigitalOcean {
    
    let host:String = "api.digitalocean.com";
    
    var _bearer:String
    
    init(token:String) {
        self._bearer = token;
    }
    
    internal func setToken(token:String) {
        self._bearer = token;
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

    private func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession()
                .dataTaskWithRequest(request) {
                    (data, response, error) -> Void in
                    if (error != nil) {
                        callback("", error.localizedDescription)
                    } else {
                        callback(NSString(data: data,
                            encoding: NSUTF8StringEncoding)!, nil)
                    }
            }
            
            task.resume()
    }
    
    private func HTTPGet(url: NSURL, callback: (String, String?) -> Void) {
        let bearer = self._bearer
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        HTTPsendRequest(request, callback)
    }
    
    private func HTTPPostJSON(url: NSURL, jsonObj: AnyObject, callback: (String, String?) -> Void) {
        let bearer = self._bearer
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonString = JSONStringify(jsonObj)
        let data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        request.HTTPBody = data
        HTTPsendRequest(request, callback)
    }
    
    func powerOn(id: NSInteger) -> Void {
        let url = NSURL(scheme:"https", host: self.host, path: "/v2/droplets/\(id)/actions");
        HTTPPostJSON(url!, jsonObj: ["type": "power_on"]) {
            (jsonString: String, error: String?) -> Void in
            let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding);
            if (error != nil) {
                println(error)
            } else {
                var jsonError:NSError?
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                
            }
        }
    }
    
    func getDroplets(callback: (NSDictionary, NSError?) -> Void) {
        let url = NSURL(scheme:"https", host: self.host, path: "/v2/droplets?page=1&per_page=1");
     
        HTTPGet(url!) {
            (jsonString: String, error: String?) -> Void in
            let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding);
            if (error != nil) {
                var err = NSError(domain: "onderweg.eu", code: 5, userInfo: ["message": error!]);
                callback(NSDictionary(), err);
            } else {
                var jsonError:NSError?
                var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSDictionary
                callback(json, jsonError);
            }
        }
 
    }
}