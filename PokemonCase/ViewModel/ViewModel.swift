//
//  ViewModel.swift
//  PokemonCase
//
//  Created by Unsal Oner on 23.03.2023.
//

import Foundation
import UIKit

struct ViewModel {
    
    // fetchPokemons
    func fetchPokemons(offset: Int = 0, limit: Int = 20, completion: @escaping(Pokemon?) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response,error in
            if error != nil {
            print(error?.localizedDescription ?? "Error")
        }
            if let data = data {
                do{
                    let pokeList = try JSONDecoder().decode(Pokemon.self, from: data)
                    completion(pokeList)
                }catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
    // downloadPokemonImage
    
    func downloadPokemonImage(pokemonID: Int , completion: @escaping (ImageListModel?) -> Void) {
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonID)")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
            if let data = data {
                do{
                    let pokeImageList = try JSONDecoder().decode(PokemonImage.self, from: data)
                    let imageListModel = ImageListModel(images: pokeImageList, pokemonID: pokemonID)
                    completion(imageListModel)
                }catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
    func fetchPokemonAbilities(pokemonId: Int, completion: @escaping ([String]) -> Void) {
        let apiUrl = "https://pokeapi.co/api/v2/pokemon/\(pokemonId)/"
        
        guard let url = URL(string: apiUrl) else { return }
        
       let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let pokemon = try JSONDecoder().decode(PokemonImage.self, from: data)
                let abilities = pokemon.abilities.map { $0.ability.name }
                completion(abilities)
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

  
}
struct ViewListModel {
    
    let pokemons: Result
    
    init(pokemons: Result) {
        self.pokemons = pokemons
    }
    
    var pokeName: String {
        return self.pokemons.name
    }
    
    var url: String {
        return self.pokemons.url
    }
    
}

struct ImageListModel {
    
    let images: PokemonImage
    let pokemonID: Int
    
    init(images: PokemonImage, pokemonID: Int) {
        self.images = images
        self.pokemonID = pokemonID
    }
    
    var imageUrl:String {
        return self.images.sprites.frontDefault
    }
    
}
