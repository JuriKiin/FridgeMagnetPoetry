//
//  ViewController.swift
//  Magneto-1
//
//  Created by Juri Kiin on 2/4/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let words = ["could","cloud","bot","bit","ask","a","geek","flame","file","ed","ed","create","like","lap","is","ing","I","her","drive","get","soft","screen","protect","online","meme","to","they","that","tech","space","source","y","write","while"]
    
    var wordArray = [UILabel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlaceWords()
        
    }
    
    func PlaceWords(){
        
        //For each word in the array
        for word in words{
            //Create a label for it
            let l = UILabel()
            //Set the label properties
            l.backgroundColor = UIColor(red: 0xF0, green: 0xF0, blue: 0xC9, alpha: 1.0)
            l.text = "   \(word)   "
            l.font = l.font.withSize(20)
            l.sizeToFit()
            wordArray.append(l)
            view.addSubview(l)
            //Make it interactable
            l.isUserInteractionEnabled = true
            //Add a pan gesture to the label
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
            l.addGestureRecognizer(panGesture)
        }
        organizeWords()
    }
    
    func organizeWords(){
        
        //Get properties of view size we need to use to display the labels
        let widthMargin = 50
        let heightMargin = 30
        let screenWidth = view.frame.width
        let startXPosition:CGFloat = 50
        var startYPosition:CGFloat = 50
        var count: CGFloat = 0
        let labelHeight = wordArray[0].frame.height + CGFloat(heightMargin)
        
                //Set the first index of the array
        wordArray[0].center = CGPoint(x: startXPosition, y: startYPosition)
        
        //Loop through each word and make rows
        for i in 1...wordArray.count-1{
            wordArray[i].center = CGPoint(x: wordArray[i-1].frame.maxX + CGFloat(widthMargin), y: startYPosition)
            count += 1.0
            //If we have reached the end of the view, wrap around
            if wordArray[i].frame.maxX > screenWidth {
                count = 0.0
                startYPosition += labelHeight
                wordArray[i].center = CGPoint(x: CGFloat(count) * startXPosition + CGFloat(widthMargin), y: startYPosition)
            }
        }
    }
    
    //This function clears all UILabels from the viewall
    // (Used when loading a new word set)
    func clearBoard(){
        for v in view.subviews{
            if v is UILabel{
                v.removeFromSuperview()
            }
        }
    }
    
    @objc func doPanGesture(panGesture:UIPanGestureRecognizer){
        //Get positions and update label position
        let label = panGesture.view as! UILabel
        let position = panGesture.location(in: view)
        label.center = position
    }


}

