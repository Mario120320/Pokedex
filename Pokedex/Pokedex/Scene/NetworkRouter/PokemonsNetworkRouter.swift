//
//  PokemonsNetworkRouter.swift
//  Pokedex
//
//  Created by Mario Chávez on 21/12/22.
//

import Foundation
import Alamofire

struct PokemonsNetworkRouter: NetworkRouter {
    var parameters: [String : Any]?


    var method: Alamofire.HTTPMethod {
        .get
    }

    var path: String {
        "api/v2/pokemon/"
    }
}
