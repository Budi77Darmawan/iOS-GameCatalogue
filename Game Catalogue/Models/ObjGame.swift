//
//  ObjGame.swift
//  Game Catalogue
//
//  Created by Budi Darmawan on 26/09/21.
//

import RealmSwift

class ObjGame: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var descriptionn: String = ""
  @objc dynamic var metacritic: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var released: String? = ""
  @objc dynamic var backgroundImage: String = ""
  @objc dynamic var rating: Float = 0
  @objc dynamic var ratingTop: Float = 0
  @objc dynamic var ratingsCount: Int = 0
  @objc dynamic var esrbRating: ObjEsrb? = nil
  var genres: List<ObjGenre> = List()
  var publishers : List<ObjPublisher> = List()
  var parentPlatforms: List<ObjPlatforms> = List()
  var developers: List<ObjDevelopers> = List()
}

class ObjGenre: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
}

class ObjEsrb: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
}

class ObjPlatforms: Object {
  @objc dynamic var platform: ObjPlatform? = nil
}

class ObjPlatform: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
}

class ObjDevelopers: Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var backgroundImage: String = ""
}

class ObjPublisher : Object {
  @objc dynamic var id: Int = 0
  @objc dynamic var slug: String = ""
  @objc dynamic var name: String = ""
  @objc dynamic var backgroundImage: String = ""
}
