//
//  ViewController.swift
//  Magneto-1
//
//  Created by Juri Kiin on 2/4/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let wordManager = WordStorage()
    var currentWordSet: Wordset!
    var wordArray = [UILabel]()
    
    //Outlets
    @IBOutlet var wordCollectionView: UICollectionView!
    
    @IBOutlet var wordSetHeader: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    //Actions
    @IBAction func decrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step:-1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    @IBAction func incrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step:1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    @IBAction func showInfoWindow(_ sender: Any) {
        return
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWordSet.wordList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.wordLabel.text = currentWordSet.wordList[indexPath.row]
        cell.wordLabel.layer.borderColor = UIColor.black.cgColor
        cell.wordLabel.layer.borderWidth = 2.0
        
        //Add touch hold recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addWord(longPress:)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        return cell
    }
    
    @objc func addWord(longPress: UILongPressGestureRecognizer){
        
        if longPress.state == UIGestureRecognizerState.began {
            let l = UILabel()
            //Set the label properties
            let cell = longPress.view as! CustomCollectionViewCell
            l.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            l.text = "   \(cell.wordLabel.text!)   "
            l.font = l.font.withSize(20)
            l.layer.borderColor = UIColor.black.cgColor
            l.layer.borderWidth = 1.0
            l.sizeToFit()
            wordArray.append(l)
            view.addSubview(l)
            //Make it interactable
            l.isUserInteractionEnabled = true
            //Add a pan gesture to the label
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
            l.addGestureRecognizer(panGesture)
            let position = longPress.location(in: view)
            l.center = position
            
            UIView.animate(withDuration:0.5,
                delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                animations: {
                    l.center = CGPoint(x: self.view.frame.width/2,y: self.view.frame.height/2)
                    l.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },
                completion: {(finished:Bool) in
                    UIView.animate(withDuration:0.2,
                                   delay: -0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                                   animations: {
                                    l.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
                })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCurrentWordSet()
        
        
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        //This loads all of the words on the screen for the active wordset.
        //PlaceWords()
        
    }
    
    func setCurrentWordSet(){
        currentWordSet = wordManager.returnWordSet()
        wordSetHeader.text = currentWordSet.name
    }
    
    func PlaceWords(){
        
        //For each word in the array
        for word in currentWordSet.wordList{
            //Create a label for it
            let l = UILabel()
            //Set the label properties
            l.backgroundColor = UIColor(red: 0xF0, green: 0xF0, blue: 0xC9, alpha: 1.0)
            l.text = "   \(word)   "
            l.font = l.font.withSize(20)
            l.layer.borderColor = UIColor.black.cgColor
            l.layer.borderWidth = 1.0
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
        if position.x > infoButton.frame.minX && position.y < infoButton.frame.maxY{
            infoButton.setImage(UIImage(named: "trashIcon.png"), for: UIControlState.normal)
            label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        }
        else{
            infoButton.setImage(UIImage(named: "infoIcon"), for: UIControlState.normal)
            label.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        if panGesture.state == UIGestureRecognizerState.ended && (position.x > infoButton.frame.minX && position.y < infoButton.frame.maxY){
            label.removeFromSuperview()
            wordArray.remove(at: wordArray.index(of: label)!)
            infoButton.setImage(UIImage(named: "infoIcon"), for: UIControlState.normal)
        }
        
    }


}

