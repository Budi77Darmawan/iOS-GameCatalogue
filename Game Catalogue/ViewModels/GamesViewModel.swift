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
  
  var listGames: Observable<Resource<Games>> = Observable(nil)
  var listGamesTopRated: Observable<Resource<Games>> = Observable(nil)
  var listGamesBySearch: Observable<Resource<Games>> = Observable(nil)
  var detailGame: Observable<Resource<DetailGame>> = Observable(nil)
  
  
  func getDataGames(_ page: String = "1") {
    let params: Parameters = [
      "page": page
    ]
    
    self.listGames.value = Resource.loading
    NetworkCall(url: ConstService.rawgType.games, parameters: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        self.listGames.value = Resource.success(games)
        
      case .failure(let error):
        self.listGames.value = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func getGamesTopRated() {
    let params: Parameters = [
      "page": "1",
      "ordering": "-rating"
    ]
    let uri = ConstService.rawgType.games
    
    self.listGamesTopRated.value = Resource.loading
    NetworkCall(url: uri, parameters: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        self.listGamesTopRated.value = Resource.success(games)
        
      case .failure(let error):
        self.listGamesTopRated.value = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func getDetailGameById(id: Int) {
    let uri = ConstService.rawgType.detailGameById.replacingOccurrences(of: "{id}", with: String(id))
    
    self.detailGame.value = Resource.loading
    NetworkCall(url: uri).executeQuery() {
      (result: Result<DetailGame, Error>) in
      switch result {
      case .success(let detail):
        self.detailGame.value = Resource.success(detail)
      case .failure(let error):
        self.detailGame.value = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func getGamesBySearch(query: String) {
    let params: Parameters = [
      "page": "1",
      "search": query
    ]
    let uri = ConstService.rawgType.games
    
    self.listGamesBySearch.value = Resource.loading
    NetworkCall(url: uri, parameters: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        self.listGamesBySearch.value = Resource.success(games)
        
      case .failure(let error):
        self.listGamesBySearch.value = Resource.error(error.localizedDescription, nil)
      }
    }
  }
  
  func loadNextPageGames(lastGame: Game, type: GameType) -> Bool {
    if !isLoadNextPage(lastGame, type) {
      return false
    }
    
    pages += 1
    onLoadNextPage = true
    
    var oldData = [Game]()
    let params: Parameters
    
    switch type {
    case .normal:
      params = [
        "page": pages,
      ]
      
      switch self.listGames.value {
      case .success(data: let data):
        oldData.append(contentsOf: data?.results ?? [])
      default:
        oldData = []
      }
    case .topRated:
      params = [
        "page": pages,
        "ordering": "-rating"
      ]
      
      switch self.listGamesTopRated.value {
      case .success(data: let data):
        oldData.append(contentsOf: data?.results ?? [])
      default:
        oldData = []
      }
    }
    
    NetworkCall(url: ConstService.rawgType.games, parameters: params).executeQuery() {
      (result: Result<Games, Error>) in
      switch result {
      case .success(let games):
        var newData = [Game]()
        newData.append(contentsOf: oldData)
        newData.append(contentsOf: games.results)
        
        switch type {
        case .normal:
          self.listGames.value = Resource.success(
            Games(
              count: games.count,
              next: games.next,
              previous: games.previous,
              results: newData)
          )
        case .topRated:
          self.listGamesTopRated.value = Resource.success(
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
    return true
  }
  
  private func isLoadNextPage(_ lastGame: Game, _ type: GameType) -> Bool {
    if onLoadNextPage {
      return false
    } else {
      if pages >= 4 {
        return false
      } else {
        var listGame = [Game]()
        switch type {
        case .normal:
          switch self.listGames.value {
          case .success(data: let data):
            listGame.append(contentsOf: data?.results ?? [])
          default:
            listGame = []
          }
          
        case .topRated:
          switch self.listGamesTopRated.value {
          case .success(data: let data):
            listGame.append(contentsOf: data?.results ?? [])
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
