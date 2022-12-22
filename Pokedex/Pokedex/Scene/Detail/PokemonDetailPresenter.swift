//
//  PokemonDetailPresenter.swift
//  Pokedex
//
//  Created by Mario Chávez on 22/12/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PokemonDetailPresentationLogic
{
  func presentSomething(response: PokemonDetail.Something.Response)
}

class PokemonDetailPresenter: PokemonDetailPresentationLogic
{
  weak var viewController: PokemonDetailDisplayLogic?
  
  // MARK: Do something
  
  func presentSomething(response: PokemonDetail.Something.Response)
  {
    let viewModel = PokemonDetail.Something.ViewModel()
    viewController?.displaySomething(viewModel: viewModel)
  }
}