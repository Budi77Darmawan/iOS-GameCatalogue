//
//  GamesViewModel.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 11/07/21.
//

import Foundation
import Alamofire

class GamesViewModel: NSObject {
  private var onLoadNextPage = false
  private var pages = 1
  
  private(set) var listGames = Resource<Games>.loading {
    didSet {
      self.bindListGamesToController(listGames)
    }
  }
  
  private(set) var listGamesTopRated = Resource<Games>.loading {
    didSet {
      self.bindListGamesTopRatedToController(listGamesTopRated)
    }
  }
  
  var bindListGamesToController: ((Resource<Games>) -> Void) = {_ in }
  
  var bindListGamesTopRatedToController: ((Resource<Games>) -> Void) = {_ in }
  
  func getDataGames(_ page: String = "1") {
    let params: Parameters = [
      "page": page,
      "key": ConstService.KeyAPI
    ]
    
    self.listGames = Resource.loading
    NetworkCall(url: ConstService.rawgType.games, params: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        self.listGames = Resource.success(games)
        
      case .failure(let error):
        self.listGames = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func getGamesTopRated() {
    let params: Parameters = [
      "page": "1",
      "ordering": "-rating",
      "key": ConstService.KeyAPI
    ]
    let uri = ConstService.rawgType.games
    
    self.listGamesTopRated = Resource.loading
    NetworkCall(url: uri, params: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        self.listGamesTopRated = Resource.success(games)
        
      case .failure(let error):
        self.listGamesTopRated = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func loadNextPageGames(lastGame: Game, type: GameType) {
    if !isLoadNextPage(lastGame, type) {
      return
    }
    
    pages += 1
    onLoadNextPage = true
    
    var oldData: [Game] = []
    let params: Parameters
    
    switch type {
    case .normal:
      params = [
        "page": pages,
        "key": ConstService.KeyAPI
      ]
      
      switch self.listGames {
      case .success(data: let data):
        for oldGame in data?.results ?? [] {
          oldData.append(oldGame)
        }
      default:
        oldData = []
      }
    case .topRated:
      params = [
        "page": pages,
        "ordering": "-rating",
        "key": ConstService.KeyAPI
      ]
      
      switch self.listGamesTopRated {
      case .success(data: let data):
        for oldGame in data?.results ?? [] {
          oldData.append(oldGame)
        }
      default:
        oldData = []
      }
    }
    
    NetworkCall(url: ConstService.rawgType.games, params: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        var newData: [Game] = oldData
        for newGame in games.results {
          newData.append(newGame)
        }
        
        switch type {
        case .normal:
          self.listGames = Resource.success(
            Games(
              count: games.count,
              next: games.next,
              previous: games.previous,
              results: newData)
          )
        case .topRated:
          self.listGamesTopRated = Resource.success(
            Games(
              count: games.count,
              next: games.next,
              previous: games.previous,
              results: newData)
          )
        }
        self.onLoadNextPage = false
        
      case .failure:
        self.onLoadNextPage = false
      }
    }
  }
  
  private func isLoadNextPage(_ lastGame: Game, _ type: GameType) -> Bool {
    if onLoadNextPage {
      return false
    } else {
      if pages >= 4 {
        return false
      } else {
        var listGame: [Game] = []
        switch type {
        case .normal:
          switch self.listGames {
          case .success(data: let data):
            for game in data?.results ?? [] {
              listGame.append(game)
            }
          default:
            listGame = []
          }
          
        case .topRated:
          switch self.listGamesTopRated {
          case .success(data: let data):
            for game in data?.results ?? [] {
              listGame.append(game)
            }
          default:
            listGame = []
          }
        }
        
        if listGame[listGame.count-1].id != lastGame.id {
          return false
        }
        return true
      }
    }
  }
}
