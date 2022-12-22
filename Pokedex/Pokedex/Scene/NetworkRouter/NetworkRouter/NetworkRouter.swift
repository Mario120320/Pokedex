//
//  NetworkRouter.swift
//  Pokedex
//
//  Created by Mario Chávez on 21/12/22.
//

import Foundation
import Alamofire

//Protocol that implements the Alamofire.URLRequestConvertible  and allow to specify all the information about the request.
public protocol NetworkRouter: Alamofire.URLRequestConvertible, URLConvertible {
    //Base url to communicate with the backend
    var baseURLString: String { get }
    //Type of HTTP method used with the request
    var method: Alamofire.HTTPMethod { get }
    //Endpoint path url
    var path: String { get }
    // Parameters used on the request
    var parameters: [String: Any]? { get }
    // A type used to define how a set of parameters are applied to a `URLRequest`
    var parametersEncoding: ParameterEncoding { get }
    // Extra headers that can be applied to a specific request
    var headers: HTTPHeaders? { get }
}

public extension NetworkRouter {

    var baseURLString: String {
        "https://pokeapi.co/"
    }

    var parametersEncoding: ParameterEncoding {
        URLEncoding.default
    }

    var headers: HTTPHeaders? {
        nil
    }

    /// Returns a URL request using the information on the NetworkRouter or throws if an `Error` was encountered.
    ///
    /// - throws: An error if the underlying request is nil.
    ///
    /// - returns: A URL request.
    func asURLRequest() throws -> URLRequest {
        let url = try self.baseURLString.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(self.path))
        urlRequest.httpMethod = self.method.rawValue
        return try self.parametersEncoding.encode(urlRequest, with: self.parameters)
    }

    /// Returns a URL using the NetworkRouter info or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL {
        let url = try self.baseURLString.asURL()
        return url.appendingPathComponent(self.path)
    }
}
