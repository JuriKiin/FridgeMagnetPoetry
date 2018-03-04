//
//  WordStorage.swift
//  Fridge Magnet Poetry
//
//  Created by Juri Kiin on 2/15/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import Foundation

class WordStorage{
    
    var wordsets: [Wordset]   //Array of wordsets
    var wordsetIncrement: Int = 0
    var activeWordSet:Wordset
    
    init(){
        self.wordsets = []
        self.activeWordSet = Wordset(name: "temp", words: [])
        generateWordSets()
    }
    
    func generateWordSets(){
        //Word Sets
        let genericWords: [String] = ["could","cloud","bot","bit","ask","a","geek","flame","file","create","like","lap","is","drive","get","soft","screen","protect","online","meme","to","that","tech","space","source","write","while","help","blood","government","reside","together","over","the","TV","prison","smile"]
        let emojis: [String] = ["😀", "😁", "😂", "🤣","😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎", "😍", "😘", "😗", "😙", "😚", "☺️", "🙂", "🤗", "🤔", "😐", "😑", "😶", "🙄", "😏", "😣", "😥"]
        let natureWords: [String] = ["tree", "leaves","pond", "spring", "summer", "fall", "winter", "birds", "natural","shelter","wild","animal","branch","hole","moon","sun","star","sky","resource"]
        let actionWords: [String] = ["kick", "push", "call", "breathe", "sprint", "walk", "stall", "freeze", "believe", "forget", "scream", "build", "speak","forgive","think","ask","wish","create","earn","scan","crumble","break","stack","proclaim","fly","swim","climb",]
        let properNouns: [String] = ["I", "me", "you", "him", "her", "they", "them", "us", "our", "his", "hers", "theirs", "ours"]
        let emotionWords: [String] = ["happy","sad","angry","upset","delight","meloncholy","detest","celebrate","encourage","gleefull","surprise","content","isolate","confuse"]
        let extensionWords: [String] = ["ing","ed","d","s","er","y","ful"]
        let punctuationWords: [String] = [".",",","!","?","/","+","-"]
        
        let genericWordSet = Wordset(name: "Generic", words: genericWords)
        wordsets.append(genericWordSet)
        let emotionWordSet = Wordset(name: "Emotions", words: emotionWords)
        wordsets.append(emotionWordSet)
        let actionWordSet = Wordset(name: "Actions", words: actionWords)
        wordsets.append(actionWordSet)
        let properNounSet = Wordset(name: "Proper Nouns", words: properNouns)
        wordsets.append(properNounSet)
        let natureWordSet = Wordset(name: "Nature", words: natureWords)
        wordsets.append(natureWordSet)
        let extensionWordSet = Wordset(name: "Extensions", words: extensionWords)
        wordsets.append(extensionWordSet)
        let punctWordSet = Wordset(name: "Punctuation", words: punctuationWords)
        wordsets.append(punctWordSet)
        let emojiWordSet = Wordset(name: "Emojis", words: emojis)
        wordsets.append(emojiWordSet)
    }
    //functions
    
    //Returns our currentWordSet
    func returnWordSet() -> Wordset {
        activeWordSet = wordsets[wordsetIncrement]
        return activeWordSet
    }
    
    //Increments the wordSet to load into the UICustomTableView
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
