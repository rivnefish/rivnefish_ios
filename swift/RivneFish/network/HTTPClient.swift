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

    func request(_ urlString: NSString, responseCallback: @escaping (_ data: Data?, _ response: URLResponse?, _ error: NSError?) -> Void) {
        let authValue: String = "Token " + self.token()

        let configuration = URLSessionConfiguration.default;
        configuration.httpAdditionalHeaders = ["Authorization": authValue];

        let url = URL(string: urlString as String)
        let session = URLSession(configuration:configuration)
        let task = session.dataTask(with: url!) { (data:Data?, response:URLResponse?, error:Error?) in
            responseCallback(data, response, error as NSError?)
        }
        task.resume()
    }
}
