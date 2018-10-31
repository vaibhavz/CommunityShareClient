//
//  NetworkInterface.swift
//  BikeShare
//
//  Created by Joyal Serrao on 21/10/18.
//  Copyright © 2018 Joyal. All rights reserved.
//
import Foundation
typealias TransportCompletionType = (Bool, Any?, HTTPURLResponse?, Error?, [AnyHashable:Any]?) -> (Void)



    class NetworkInterface: NSObject {
        /// Call
        static func fetchJSON(_ requestType:BikeRequestType , headers:NSDictionary? = [:], params:NSDictionary? = [:], requestCompletionHander:@escaping TransportCompletionType) -> URLSessionDataTask {
            
            return self.sendAsyncRequest(BikeNetworkRequest.getRequestofType(requestType, headers: headers, urlParams: params)) { (success, json, response, error, headers) -> (Void) in
                if (success == true && response != nil) {
                    let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                    let httpStatusCode = httpResponse.statusCode
                    switch httpStatusCode {
                    case 200:
                        let succcess = (json != nil)
                        if (succcess) {
                            requestCompletionHander(succcess, json, response, nil, httpResponse.allHeaderFields)
                        } else {
                            requestCompletionHander(false, nil, response , DataErrors.invalidJSONData, httpResponse.allHeaderFields)
                        }
                        break
                    case 204:
                        requestCompletionHander(false, nil, response, BikeNetworkError.httpStatus204, httpResponse.allHeaderFields)
                        break
                    case 404:
                        requestCompletionHander(false,nil,response,BikeNetworkError.httpStatus404, httpResponse.allHeaderFields)
                        break
                    case 410:
                        requestCompletionHander(false, nil, response, BikeNetworkError.httpStatus410, httpResponse.allHeaderFields)
                        break

                    default:
                        requestCompletionHander(false,nil,response,BikeNetworkError.httpStatusUnknownError, httpResponse.allHeaderFields)
                        break
                    }
                }
                else {
                    requestCompletionHander(false,nil,response,error, nil)
                }
            }
        }
        

        ///postCall Request method(postRequest) Name has been changed for easy to understand esy to get.
        /// - Parameters:
        ///   - requestType: thomeRequestType(Check Enum)
        ///   - headers: Input required Heders as dictionary
        ///   - payload: Input required payload(body) as dictionary
        ///   - requestCompletionHander:
        /// - Returns:URLSessionDataTask(A URL session task that returns downloaded data)
        static func postRequest(_ requestType:BikeRequestType , headers:NSDictionary? = [:], params: NSDictionary? = [:],  payload :[String:Any]  , requestCompletionHander:@escaping TransportCompletionType) -> URLSessionDataTask{
            debugPrint(headers!)
            debugPrint(payload)
           
            return self.sendAsyncRequest(BikeNetworkRequest.postRequestofType(requestType, headers: headers, urlParams:params, payload: payload  ), completionHandler: { (suc, json, response, error, headers) -> (Void) in
                
                let succcess = (json != nil)
                requestCompletionHander(succcess,json, response,error, headers)
                
            })
        }
        
        
        
        /// deleteCall Request method(deleteRequest) Name has been changed for easy to understand easy to get.
        /// - Parameters:
        ///   - requestType: thomeRequestType(Check Enum)
        ///   - headers: Input required Heders as dictionary
        ///   - params:  Input required urlparms
        ///   - payload: Input required payload(body) as dictionary
        ///   - requestCompletionHander:
        /// - Returns:URLSessionDataTask(A URL session task that returns downloaded data)
        static func deleteRequest(_ requestType:BikeRequestType , headers:NSDictionary? = [:],extendIdUrl:String?,params: NSDictionary? = [:], payload :[String:Any]  , requestCompletionHander:@escaping TransportCompletionType) -> URLSessionDataTask{
            
            return self.sendAsyncRequest(BikeNetworkRequest.deleteRequestofType(requestType, headers: headers, extendIdUrl: extendIdUrl, urlParams: params, payload: payload  ), completionHandler: { (suc, json, response, error, headers) -> (Void) in
                let succcess = (json != nil)
                requestCompletionHander(succcess,json, response,error, headers)
                
            })
        }
        
        
        
        ///putRequestCall Request method(putRequestWithID) Name has been changed for easy to understand easy to get.
        ///   - requestType: thomeRequestType(Check Enum)
        ///   - headers: Input required Heders as dictionary
        ///   - params:  Input required urlparms
        ///   - payload: Input required payload(body) as dictionary
        ///   - requestCompletionHander:
        /// - Returns:URLSessionDataTask(A URL session task that returns downloaded data)
        static func putRequestWithID(_ requestType:BikeRequestType , headers:NSDictionary? = [:],extendIdUrl : String, params: NSDictionary? = [:],  payload :[String:Any]?  , requestCompletionHander:@escaping TransportCompletionType) -> URLSessionDataTask{
            
            return self.sendAsyncRequest(BikeNetworkRequest.putRequestofType(requestType, headers: headers, extendIdUrl: extendIdUrl, urlParams:params, payload: payload  ), completionHandler: { (suc, json, response, error, headers) -> (Void) in
                let succcess = (json != nil)
                requestCompletionHander(succcess,json, response,error, headers)
                
            })
        }
        
        
        static fileprivate func sendAsyncRequest(_ request:URLRequest, completionHandler:@escaping TransportCompletionType) -> URLSessionDataTask{
            
            let task = URLSession.shared.dataTask(with: request) { ( data,response, error) in
                DispatchQueue.main.async {
                    
                    if let dataInfo = data {
                        
                        completionHandler(true, dataInfo,response as? HTTPURLResponse,DataErrors.dataParseError, nil)
                    }
                    
                }
            }
            task.resume()
            return task
        }
    }


