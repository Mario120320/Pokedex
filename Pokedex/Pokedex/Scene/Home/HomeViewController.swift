//
//  HomeViewController.swift
//  Pokedex
//
//  Created by Mario Chávez on 16/12/22.
//

import UIKit
import Kingfisher

protocol HomeDisplayInterface: AnyObject {
    func displayPokemon(viewModel: HomeModels.fetchPokemon.ViewModel)
    func displaySearchPokemon(viewModel: HomeModels.searchPokemon.ViewModel)
    func displayDetailPokemon(viewModel: HomeModels.searchPokemon.ViewModel)

}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldSearch: UITextField!
    
    
    // MARK: - Properties
    var interactor: HomeInteractorInterface?
    private var viewModel = HomeModels.fetchPokemon.ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        interactor?.fetchPokemons()
    }
    
    // MARK: - Setup
    private func setup() {
        setupUI()
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        viewController.interactor = interactor
        //        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        //        router.viewController = viewController
        //        router.dataStore = interactor
        //
        //        interactor.fetchCouponsPopularWords()
        //        self.searchPromotions(text: "most_visited")
    }
    private func setupUI() {
        //CollectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        //TextField
        textFieldSearch.delegate = self
    }
}

// MARK: - HomeDisplayLogic

extension HomeViewController: HomeDisplayInterface {
    func displayPokemon(viewModel: HomeModels.fetchPokemon.ViewModel) {
        self.viewModel = viewModel
        if let errorMessage = viewModel.errorMessage {
            //                Error message
            alert(title: "Aviso", subTitle: errorMessage)
        } else {
            if viewModel.pokemon.count == 0 {
                //                Empty Message
                alert(title: "Aviso", subTitle: viewModel.emptyMessage ?? "No se encontró ningún pokemon")
            }
            else {
                collectionView.reloadData()
            }
        }
    }
    
    func displaySearchPokemon(viewModel: HomeModels.searchPokemon.ViewModel) {
        collectionView.isHidden = true  
        let name = viewModel.name
        let image = viewModel.sprites?.frontDefault
        FoundPokemon.present(initialView: self, delegate: self, name: name, image: image ?? "")
    }
    
    func displayDetailPokemon(viewModel: HomeModels.searchPokemon.ViewModel) {
        collectionView.isHidden = true
        let name = viewModel.name
        let image = viewModel.sprites?.frontDefault
        // Show infoPokemon
        
        print(name)
    }
    
    func alert(title: String, subTitle: String) {
        let alert = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}

// MARK: - CollectionView

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        let index = (indexPath as NSIndexPath).row
        configureCell(cell, at: index)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: UICollectionViewCell, at index: Int) {
        cell.backgroundColor = .clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.self.height))
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        let numberOfPokemon = getNumberOfPokemon(index: index)
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(numberOfPokemon).png")
        imageView.kf.setImage(with: url)
        cell.addSubview(imageView)
    }
    
    func getNumberOfPokemon(index: Int) -> String{
        var urlStr = viewModel.pokemon[index].url
        urlStr.removeLast()
        let numPokemon = urlStr.subString(from: 34, to: urlStr.count)
        
        print("Numero de Pokemón: \(numPokemon)")
        return numPokemon
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Seleccionó a: \(viewModel.pokemon[indexPath.row].name)")
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = 70.0
        let height : CGFloat = 70.0
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let offset: CGFloat = 0.0
        
        return UIEdgeInsets(top: 0, left: offset , bottom: 0, right: offset)
    }
}

// MARK: - Search
extension HomeViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchPokemon(_:)), object: textField)
        perform(#selector(self.searchPokemon(_:)), with: textField, afterDelay: 0.5)
        return true
    }
    
    @objc func searchPokemon(_ searchPokemn: UITextField) {
        if searchPokemn.text == "" {
            collectionView.isHidden = false
        }
        else {
            let request = HomeModels.searchPokemon.Request(pokemon: searchPokemn.text ?? "", type: 0)
            interactor?.searchPokemon(request: request)
        }
    }
}


extension String {
    func subString(from: Int, to: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[startIndex..<endIndex])
    }
}

extension HomeViewController: FoundPokemonModalDelegate {
    func didTapAccept(pokemonSelected: String) {
        self.dismiss(animated: true)
        let request = HomeModels.searchPokemon.Request(pokemon: pokemonSelected, type: 1)
        interactor?.searchPokemon(request: request)
    }
    
    func didTapCancel() {
        self.dismiss(animated: true)
        textFieldSearch.text = ""
        collectionView.isHidden = false
    }
}
