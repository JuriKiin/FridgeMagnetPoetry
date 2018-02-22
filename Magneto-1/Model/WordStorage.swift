//
//  WordStorage.swift
//  FridgeMagnet
//
//  Created by Juri Kiin on 2/15/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import Foundation

class WordStorage{
    
    var wordsets: [Wordset]   //Array of wordsets
    var wordsetIncrement: Int = 0

    
    init(){
        self.wordsets = []
        generateWordSets()
    }
    
    func generateWordSets(){
        //Word Sets
        let genericWords: [String] = ["could","cloud","bot","bit","ask","a","geek","flame","file","ed","ed","create","like","lap","is","ing","I","her","drive","get","soft","screen","protect","online","meme","to","they","that","tech","space","source","y","write","while"]
        let emojis: [String] = ["😀", "😁", "😂", "🤣","😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😍", "😘", "😗", "😙", "😚", "☺️", "🙂", "🤗", "🤔", "😐", "😑", "😶", "🙄", "😏", "😣", "😥"]
        let natureWords: [String] = ["tree", "leaves","pond"]
        let sportsWords: [String] = ["soccer", "Liverpool FC"]
        
        
        let genericWordSet = Wordset(name: "Generic", words: genericWords)
        wordsets.append(genericWordSet)
        let natureWordSet = Wordset(name: "Nature", words: natureWords)
        wordsets.append(natureWordSet)
        let sportsWordSet = Wordset(name: "Sports", words: sportsWords)
        wordsets.append(sportsWordSet)
        let emojiWordSet = Wordset(name: "Emojis", words: emojis)
        wordsets.append(emojiWordSet)
    }
    
    
    
    //functions
    func returnWordSet() -> Wordset {
        return wordsets[wordsetIncrement]
    }
    
    func incrementWordSet(step: Int) -> Wordset{
        wordsetIncrement = wordsetIncrement + step
        if wordsetIncrement == wordsets.count{
            wordsetIncrement = 0
        }
        if wordsetIncrement < 0{
            wordsetIncrement = wordsets.count-1
        }
        return returnWordSet()
    }
}
