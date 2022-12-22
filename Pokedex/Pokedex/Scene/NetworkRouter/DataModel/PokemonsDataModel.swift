//
//  PokemonsDataModel.swift
//  Pokedex
//
//  Created by Mario Chávez on 21/12/22.
//

import Foundation

struct PokemonsDataModel: Codable {
    let count: Int?
    let next: String?
    let previus: String?
    
    let results: [Pokemon]
    
    struct Pokemon: Codable {
        let name: String
        let url: String
    }
}

struct PokemonSearchDataModel: Decodable {
    let id: Int
    let name: String
    let sprites: Sprites
    let types: [types]
    
    struct Sprites: Decodable {
        let backDefault: String?
        let backFemale: String?
        let backShiny: String?
        let backShiny_female: String?
        let frontDefault: String?
        let frontFemale: String?
        let frontShiny: String?
        let frontShiny_female: String?
        
        private enum CodingKeys: String, CodingKey {
            case backDefault = "back_default"
            case backFemale = "back_female"
            case backShiny = "back_shiny"
            case backShiny_female = "back_shiny_female"
            case frontDefault = "front_default"
            case frontFemale = "front_female"
            case frontShiny = "front_shiny"
            case frontShiny_female = "front_shiny_female"
        }
    }
    struct types: Decodable {
        var slot: Int
        var type: type
    }
    
    struct type: Codable {
        let name: String
        let url: String?
    }
}
