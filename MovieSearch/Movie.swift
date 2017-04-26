//
//  Movie.swift
//  MovieSearch
//
//  Created by Kevin Lee on 10/19/16.
//  Copyright © 2016 Kevin Lee. All rights reserved.
//

struct Movie {
    var title: String
    var release: String
    var rating: String
    var plot: String
    var poster: String
    var favorite: Bool
    
    mutating func makeFavorite() {
        self.favorite = true
    }
    mutating func unFavorite() {
        self.favorite = false
    }
}
