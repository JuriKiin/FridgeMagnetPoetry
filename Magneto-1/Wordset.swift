//
//  Wordset.swift
//  FridgeMagnet
//
//  Created by Juri Kiin on 2/15/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import Foundation

class Wordset{
    
    let name: String
    var wordList: [String]
    
    init(name: String, words: [String]) {
        self.name = name
        self.wordList = words
    }
}
