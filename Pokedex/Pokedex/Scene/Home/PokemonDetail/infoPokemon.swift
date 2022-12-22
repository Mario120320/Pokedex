//
//  infoPokemon.swift
//  Pokedex
//
//  Created by Mario Chávez on 22/12/22.
//

import UIKit

public protocol infoPokemonModalDelegate: AnyObject {
    func didTapAccept(pokemonSelected: String)
}

class infoPokemon: UIViewController {
    public weak var delegate: infoPokemonModalDelegate?

    var pokemonName: String?
    var pokemonImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private static func create(delegate: infoPokemonModalDelegate, viewModel: HomeModels.searchPokemon.ViewModel) -> infoPokemon {
        let view = infoPokemon(delegate: delegate, viewModel: viewModel)
        return view
    }
    
    @discardableResult
    static public func present( initialView: UIViewController, delegate: infoPokemonModalDelegate, viewModel: HomeModels.searchPokemon.ViewModel) -> infoPokemon {
        let view = infoPokemon.create(delegate: delegate, viewModel: viewModel)
        view.modalPresentationStyle = .overFullScreen
        initialView.present(view, animated: true)
        return view
    }
    
    
    public init(delegate: infoPokemonModalDelegate, viewModel: HomeModels.searchPokemon.ViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pokemonName = viewModel.name
        self.pokemonImage = viewModel.sprites?.frontDefault
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
