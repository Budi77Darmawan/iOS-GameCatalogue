//
//  Games.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 11/07/21.
//

import Foundation

struct ResultGames {
  var result: Resource<Games>
}

struct Games: Decodable {
  let count: Int
  let next: String?
  let previous: String?
  let results: [Game]
}

struct Game: Decodable {
  let id: Int
  let slug: String
  let name: String
  let released: String?
  let backgroundImage: String?
  let rating: Float?
  let ratingTop: Float?
  let ratingCount: Int?
  
  enum CodingKeys: String, CodingKey {
    case id, slug, name, released, rating
    case ratingTop = "rating_top"
    case ratingCount = "ratings_count"
    case backgroundImage = "background_image"
  }
}

struct Genre: Decodable {
  let id: Int
  let slug: String
  let name: String
}

struct DetailGame: Decodable {
  let id: Int
  let description: String
  let metacritic: Int?
  let slug: String
  let name: String
  let released: String?
  let backgroundImage: String?
  let rating: Float?
  let ratingTop: Float?
  let ratingCount: Int?
  let esrbRating: Esrb?
  let genres: [Genre]
  let publishers : [Publisher]
  let parentPlatforms: [Platforms]
  let developers: [Developers]
  
  enum CodingKeys: String, CodingKey {
    case id, slug, name, released, rating, metacritic, genres, publishers, developers
    case description = "description_raw"
    case ratingTop = "rating_top"
    case ratingCount = "ratings_count"
    case backgroundImage = "background_image"
    case esrbRating = "esrb_rating"
    case parentPlatforms = "parent_platforms"
  }
}

struct Esrb: Decodable {
  let id: Int
  let slug: String
  let name: String
}

struct Platforms: Decodable {
  let platform: Platform
}

struct Platform: Decodable {
  let id: Int
  let slug: String
  let name: String
}

struct Developers: Decodable {
  let id: Int
  let slug: String
  let name: String
  let backgroundImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, slug, name
    case backgroundImage = "image_background"
  }
}

struct Publisher : Decodable {
  let id : Int
  let slug: String
  let name : String
  let backgroundImage: String
  
  enum CodingKeys: String, CodingKey {
    case id, slug, name
    case backgroundImage = "image_background"
  }
}

