//
//  NetworkManager.swift
//  RivneFish
//
//  Created by akyryl on 04/07/2015.
//  Copyright (c) 2015 rivnefish. All rights reserved.
//

import Foundation

class HTTPClient {

    static let sharedInstance = HTTPClient()

    func token() -> String {
        // TODO: read from keychain
        return "9a19e9e3082e5ac1b7dd47572bdc1153fd735c68"
    }

    func request(urlString: NSString, responseCallback: (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void) {
        let authValue: String = "Token " + self.token()

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration();
        configuration.HTTPAdditionalHeaders = ["Authorization": authValue];

        let url = NSURL(string: urlString as String)
        let session = NSURLSession(configuration:configuration)
        let task = session.dataTaskWithURL(url!) {
            (data, response, error) in
            responseCallback(data: data, response: response, error: error)
        }
        task.resume()
    }
}
