//
//  DatabaseCall.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 26/09/21.
//

import Foundation
import RealmSwift

class DatabaseCall {
  
  static func getGamesOnDatabase() -> [DetailGame] {
    var result: [DetailGame] = []
    do {
      let realmDB = try Realm()
      let gameDB = realmDB.objects(ObjGame.self)
      
      for game in gameDB {
        let dataGame = mapObjGameToDetailGame(game: game)
        result.append(dataGame)
      }
      
    } catch let error {
      print(error.localizedDescription)
      return result
    }
    return result
  }
  
  static func getGameById(id: Int) -> DetailGame? {
    var result: DetailGame? = nil
    do {
      let realmDB = try Realm()
      let gameDB = realmDB.objects(ObjGame.self)
      
      guard let game = gameDB.first(where: { $0.id == id })
      else {
        return nil
      }
      result = mapObjGameToDetailGame(game: game)
    } catch let error {
      print(error.localizedDescription)
      return nil
    }
    return result
  }
  
  static func addToDatabase(game: DetailGame) -> Bool {
    do {
      let realmDB = try Realm()
      let gameDB = realmDB.objects(ObjGame.self)
      
      if !gameDB.isEmpty {
        guard let _ = gameDB.first(
                where: { $0.id != game.id })
        else {
          return true
        }
      }

      
      let dataMap = mapDetailGameToObjGame(game: game)
      try realmDB.write {
        realmDB.add(dataMap)
      }
      
    } catch let error {
      print(error.localizedDescription)
      return false
    }
    return true
  }
  
  static func deleteFromDatabase(gameId: Int) -> Bool {
    do {
      let realmDB = try Realm()
      let gameDB = realmDB.objects(ObjGame.self)
      
      guard let dataGame = gameDB.first(
              where: { $0.id == gameId })
      else {
        return false
      }
      
      try realmDB.write {
        realmDB.delete(dataGame)
      }
    } catch let error {
      print(error.localizedDescription)
      return false
    }
    return true
  }
  
  private static func mapObjGameToDetailGame(game: ObjGame) -> DetailGame {
    let dataEsrb = Esrb(
      id: game.esrbRating?.id ?? 0,
      slug: game.esrbRating?.slug ?? "",
      name: game.esrbRating?.name ?? ""
    )
    
    let dataGenre: [Genre] = game.genres.map { gen in
      Genre(id: gen.id, slug: gen.slug, name: gen.name)
    }
    
    let dataPublisher: [Publisher] = game.publishers.map { pub in
      Publisher(id: pub.id, slug: pub.slug, name: pub.name, backgroundImage: pub.backgroundImage)
    }
    
    let dataDeveloper: [Developers] = game.developers.map { dev in
      Developers(id: dev.id, slug: dev.slug, name: dev.name, backgroundImage: dev.backgroundImage)
    }
    
    let dataPlatforms: [Platforms] = game.parentPlatforms.map { ObjPlatforms in
      Platforms(platform: Platform(id: ObjPlatforms.platform?.id ?? 0,
                                   slug: ObjPlatforms.platform?.slug ?? "",
                                   name: ObjPlatforms.platform?.name ?? "")
      )
    }
    
    return DetailGame(
      id: game.id,
      description: game.descriptionn,
      metacritic: game.metacritic,
      slug: game.slug,
      name: game.name,
      released: game.released,
      backgroundImage: game.backgroundImage,
      rating: game.rating,
      ratingTop: game.ratingTop,
      ratingCount: game.ratingsCount,
      esrbRating: dataEsrb,
      genres: dataGenre,
      publishers: dataPublisher,
      parentPlatforms: dataPlatforms,
      developers: dataDeveloper)
  }
  
  private static func mapDetailGameToObjGame(game: DetailGame) -> ObjGame {
    let dataEsrb = ObjEsrb()
    dataEsrb.id = game.esrbRating?.id ?? 0
    dataEsrb.slug = game.esrbRating?.slug ?? ""
    dataEsrb.name = game.esrbRating?.name ?? ""
    
    let dataGenre: List<ObjGenre> = List.init()
    for genre in game.genres {
      let gen = ObjGenre()
      gen.id = genre.id
      gen.slug = genre.slug
      gen.name = genre.name
      dataGenre.append(gen)
    }
    
    let dataPublisher: List<ObjPublisher> = List.init()
    for publisher in game.publishers {
      let pub = ObjPublisher()
      pub.id = publisher.id
      pub.slug = publisher.slug
      pub.name = publisher.name
      pub.backgroundImage = publisher.backgroundImage
      dataPublisher.append(pub)
    }
    
    let dataDeveloper: List<ObjDevelopers> = List.init()
    for developer in game.developers {
      let dev = ObjDevelopers()
      dev.id = developer.id
      dev.slug = developer.slug
      dev.name = developer.name
      dev.backgroundImage = developer.backgroundImage
      dataDeveloper.append(dev)
    }
    
    let dataPlatforms: List<ObjPlatforms> = List.init()
    for platforms in game.parentPlatforms {
      let plats = ObjPlatforms()
      let plat = ObjPlatform()
      plat.id = platforms.platform.id
      plat.slug = platforms.platform.slug
      plat.name = platforms.platform.name
      plats.platform = plat
      dataPlatforms.append(plats)
    }
    
    let objGame = ObjGame()
    objGame.id = game.id
    objGame.descriptionn = game.description
    objGame.metacritic = game.metacritic ?? 0
    objGame.slug = game.slug
    objGame.name = game.name
    objGame.released = game.released
    objGame.backgroundImage = game.backgroundImage ?? Const.defaultUriImage
    objGame.rating = game.rating ?? 0
    objGame.ratingTop = game.ratingTop ?? 0
    objGame.ratingsCount = game.ratingCount ?? 0
    objGame.esrbRating = dataEsrb
    objGame.genres = dataGenre
    objGame.publishers = dataPublisher
    objGame.parentPlatforms = dataPlatforms
    objGame.developers = dataDeveloper
    
    return objGame
  }
  
}
