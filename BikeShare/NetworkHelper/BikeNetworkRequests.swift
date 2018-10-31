//
//  BikeNetworkRequests.swift
//  BikeShare
//
//  Created by Joyal Serrao on 21/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//
import Foundation



enum BikeRequestType{
    case allBike
    case nearByBike
    case createNewBike
    case updateBike
    case rentBike
    case returnBike
}

struct RequestConstants {
    
    //  static let EndPoint = "http://localhost:3000"
      static let EndPoint = "https://sharebike.herokuapp.com"
    // mark : Need to modifiy
}
 
 

class BikeNetworkRequest {
    
    // GET Requests
    static func getRequestofType(_ requestType:BikeRequestType, headers:NSDictionary?,  urlParams:NSDictionary?) -> URLRequest {
        var request:URLRequest!
        switch requestType {
            
        case .allBike:
            let path = "/bikes"
            let endpoint = RequestConstants.EndPoint + path
            request = self.createGETRequest(endpoint, headers: headers, urlParams: urlParams)
            break
   
        case .nearByBike:
            let path = "/bikes"
            let endpoint = RequestConstants.EndPoint + path
            request = self.createGETRequest(endpoint, headers: headers, urlParams: urlParams)
            break
       
        default:
            break
        }
        
        
        return request
    }


    // POST Requests
    static func postRequestofType(_ requestType:BikeRequestType,headers:NSDictionary?, urlParams:NSDictionary?, payload :[String:Any]? ) -> URLRequest {
        var request:URLRequest!
        switch requestType {
        case .createNewBike:
            let path = "/bikes"
            let endpoint = RequestConstants.EndPoint+path
            request = self.createPOSTRequest(endpoint, headers: headers,urlParams: urlParams, payload: payload!)
            break
        default:
            break
            
        }
        
        return request

    }
   
    
    // PUT Request
    static func putRequestofType(_ requestType:BikeRequestType,headers:NSDictionary?,extendIdUrl: String, urlParams:NSDictionary?, payload :[String:Any]? ) -> URLRequest{
        var request:URLRequest!
        switch requestType {
        case .updateBike:
          //  let id = 2// UserDefaults.standard.getUserID()
            let path = "/bikes/\(extendIdUrl)"
            let endpoint = RequestConstants.EndPoint+path
            request = self.createPUTRequest(endpoint, headers: headers, payload: payload! as NSDictionary)
            break
        case .rentBike:
            
            let path = "/bikes/\(extendIdUrl)/rented"
            let endpoint = RequestConstants.EndPoint+path
            request = self.createPUTRequest(endpoint, headers: headers, payload: nil)
            break
        default:
            break
        }
           return request
        }
   
  
    
    // Delete Requests
    static func deleteRequestofType(_ requestType:BikeRequestType,headers:NSDictionary?,extendIdUrl:String?, urlParams:NSDictionary?, payload :[String:Any]?) -> URLRequest{
        var request:URLRequest!
        switch requestType {
        case .returnBike:
              let id = extendIdUrl!// UserDefaults.standard.getUserID()
              let path = "/bikes/\(id)/rented"
            let endpoint = RequestConstants.EndPoint + path
            request = self.createDELETERequest(endpoint, headers: headers,urlParams: nil, payload: payload!)
            break
        default:
            break
        }
           return request
    }

    static func createGETRequest(_ baseURL:String , headers:NSDictionary?, urlParams:NSDictionary?) -> URLRequest {
        var headerAsString:String = ""
        if (urlParams != nil && urlParams!.count > 0) {
            var separator = "?"
            for (key,value) in urlParams! {
                
                
                headerAsString += separator
                headerAsString += key as! String
                headerAsString += "="
                if(value != nil) {
                    headerAsString += value as! String
                }
                separator = "&"
            }
        }

        headerAsString = headerAsString.folding(options: .diacriticInsensitive, locale: nil)
        let fullUrlString = baseURL + headerAsString;
        let url = URL(string: fullUrlString)//URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    static func createPOSTRequest(_ baseURL:String ,headers:NSDictionary?,urlParams: NSDictionary?, payload:[String:Any]) -> URLRequest {
        var headerAsString:String = ""
        
        if (urlParams != nil && urlParams!.count > 0) {
            var separator = "?"
            for (key,value) in urlParams! {
               // headerAsString += separator
                headerAsString += key as! String
               // headerAsString += "="
               // headerAsString += value as! String
               // separator = "&"
            }
        }
        let fullUrlString = baseURL + headerAsString;
        debugPrint(fullUrlString)

        let url = URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
            let post = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            request.httpBody = post.data(using: String.Encoding.utf8);
        }catch {
            
            print("json error: \(error)")
        }
        request.httpMethod = "POST"
        request.timeoutInterval = 80
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    static func createPOSTRequestWithFormData(_ baseURL:String ,headers:NSDictionary?, payload:NSDictionary?) -> URLRequest {
        var headerAsString:String = ""
        
        if (headers != nil && headers!.count > 0) {
            var separator = "?"
            for (key,value) in headers! {
                headerAsString += separator
                headerAsString += key as! String
                headerAsString += "="
                headerAsString += value as! String
                separator = "&"
            }
        }
        
        print(headers)
        
        let fullUrlString = baseURL + headerAsString;
        let url = URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        
        var payloadString = ""
        if (payload != nil && payload!.count > 0) {
            var separator = ""
            for (key,value) in payload! {
                payloadString += separator
                payloadString += key as! String
                payloadString += "="
                payloadString += value as! String
                separator = "&"
            }
        }
        
        request.httpBody = payloadString.data(using: String.Encoding.utf8);
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.timeoutInterval = 80
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    static fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
    static func createPATCHRequest(_ baseURL:String ,headers:NSDictionary?,urlParams: NSDictionary?, payload:[String:Any]) -> URLRequest {
        var headerAsString:String = ""
        
        if (urlParams != nil && urlParams!.count > 0) {
            var separator = "?"
            for (key,value) in urlParams! {
                headerAsString += separator
                headerAsString += key as! String
                headerAsString += "="
                headerAsString += value as! String
                separator = "&"
            }
        }
        let fullUrlString = baseURL + headerAsString;
        let url = URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
            let post = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            request.httpBody = post.data(using: String.Encoding.utf8);
        }catch {
            print("json error: \(error)")
        }
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PATCH"
        request.timeoutInterval = 80
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    static func createDELETERequest(_ baseURL:String , headers:NSDictionary?,urlParams: NSDictionary? , payload : [String:Any]) -> URLRequest {
        var headerAsString:String = ""
        
        if (headers != nil && headers!.count > 0) {
            var separator = "?"
            for (key,value) in headers! {
                headerAsString += separator
                headerAsString += key as! String
                headerAsString += "="
                headerAsString += value as! String
                separator = "&"
            }
        }
        let fullUrlString = baseURL + headerAsString;
        let url = URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: payload, options: [])
            let post = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
            request.httpBody = post.data(using: String.Encoding.utf8);
        }catch {
            print("json error: \(error)")
        }
        request.httpMethod = "DELETE"
        request.timeoutInterval = 80
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    static func createPUTRequest(_ baseURL:String ,headers:NSDictionary?, payload:NSDictionary?) -> URLRequest {
        let headerAsString:String = ""
       debugPrint(headers)
        let fullUrlString = baseURL + headerAsString;
        let url = URL(string: fullUrlString)
        let request = NSMutableURLRequest(url: url!)
        if headers != nil {
            for (key,value) in headers! {
                request.addValue(value as! String, forHTTPHeaderField: key as! String)
            }
        }
        
        if let payloadData = payload {
        do {
            let data = try JSONSerialization.data(withJSONObject: payloadData, options: [])
            let post = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String
            request.httpBody = post.data(using: String.Encoding.utf8);
        } catch {
            debugPrint("json error: \(error)")
        }
        }
        request.httpMethod = "PUT"
        request.timeoutInterval = 80
        request.httpShouldHandleCookies=false
        return request as URLRequest
    }
    
    
    
 
    
    
}

