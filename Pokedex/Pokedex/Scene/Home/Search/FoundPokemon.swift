//
//  FoundPokemon.swift
//  Pokedex
//
//  Created by Mario Chávez on 22/12/22.
//

import UIKit

public protocol FoundPokemonModalDelegate: AnyObject {
    func didTapCancel()
    func didTapAccept(pokemonSelected: String)
}

class FoundPokemon: UIViewController {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var showDetail: UIButton!
    
    public weak var delegate: FoundPokemonModalDelegate?

    var pokemonName: String?
    var pokemonImage: String?
    
    private static func create(delegate: FoundPokemonModalDelegate, name: String, image: String) -> FoundPokemon {
        let view = FoundPokemon(delegate: delegate, name: name, image: image)
        return view
    }
    
    @discardableResult
    static public func present( initialView: UIViewController, delegate: FoundPokemonModalDelegate, name: String, image: String) -> FoundPokemon {
        let view = FoundPokemon.create(delegate: delegate, name: name, image: image)
        view.modalPresentationStyle = .overFullScreen
        initialView.present(view, animated: true)
        return view
    }
    
    
    public init(delegate: FoundPokemonModalDelegate, name: String, image: String) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.pokemonName = name
        self.pokemonImage = image
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        cancel.addTarget(self, action: #selector(self.didTapCancel(_:)), for: .touchUpInside)
        showDetail.addTarget(self, action: #selector(self.didShowDetail(_:)), for: .touchUpInside)
        name.text = pokemonName
        let url = URL(string: pokemonImage ?? "")
        image.kf.setImage(with: url)
    }
    
    @objc func didTapCancel(_ btn: UIButton) {
        self.delegate?.didTapCancel()
    }
    
    @objc func didShowDetail(_ btn: UIButton) {
        self.delegate?.didTapAccept(pokemonSelected: pokemonName ?? "")
    }
}
