//
//  ViewController.swift
//  Magneto-1
//
//  Created by Juri Kiin on 2/4/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let wordManager = WordStorage()
    
    var currentWordSet: Wordset!
    var wordArray = [UILabel]()
    var currentFontSize: Double = 20.0
    var isSettingsViewOpen = false
    
    //Outlets
    @IBOutlet var wordCollectionView: UICollectionView!
    
    @IBOutlet var wordSetHeader: UILabel!
    @IBOutlet var infoButton: UIButton!
    
    //Settings
    @IBOutlet var fontNameLabel: UILabel!
    @IBOutlet var fontSizeLabel: UILabel!
    @IBOutlet var fontSizeStepper: UIStepper!
    @IBOutlet var settingsView: UIView!
    
    //Image Picker
    @IBOutlet var backgroundImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        backgroundImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    //Actions
    @IBAction func loadImagePicker(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func updateFontSize(_ sender: Any) {
        currentFontSize = fontSizeStepper.value
        for word in wordArray{
            word.font = word.font.withSize(CGFloat(currentFontSize))
            word.sizeToFit()
        }
        fontSizeLabel.text = "\(fontSizeStepper.value)"
        fontSizeLabel.sizeToFit()
    }
    
    @IBAction func toggleSettingsView(_ sender: Any) {
        settingsView.isHidden = !settingsView.isHidden
        isSettingsViewOpen = !isSettingsViewOpen
    }
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWordSet.wordList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.wordLabel.text = currentWordSet.wordList[indexPath.row]
        cell.wordLabel.layer.borderColor = UIColor.black.cgColor
        cell.wordLabel.layer.borderWidth = 2.0
        
        //Add touch hold recognizer
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(AddWord(longPress:)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadSettingsForDevice()
        settingsView.isHidden = true
        
        setCurrentWordSet()
        
        imagePicker.delegate = self
        wordCollectionView.delegate = self
        wordCollectionView.dataSource = self
        
        //This loads all of the words on the screen for the active wordset.
        //PlaceWords()
        
    }
    
    
    //FUNCTIONS
    
    func LoadSettingsForDevice(){
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            currentFontSize = 30
        }
        else{
            currentFontSize = 20
        }
    }
    
    @objc func AddWord(longPress: UILongPressGestureRecognizer){
        
        if longPress.state == UIGestureRecognizerState.began  && isSettingsViewOpen == false{
            let l = UILabel()
            //Set the label properties
            let cell = longPress.view as! CustomCollectionViewCell
            l.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            l.text = "   \(cell.wordLabel.text!)   "
            l.font = l.font.withSize(CGFloat(currentFontSize))
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
            
            //Add Long press gesture to the label
            let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(EditLabel(longPress:)))
            l.addGestureRecognizer(longPressRecognizer)
            
            //Get the position of the longPress to animate from there.
            let position = longPress.location(in: view)
            l.center = position
            
            //Add the placing word animation
            UIView.animate(withDuration:0.5,
                delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                animations: {
                    l.center = CGPoint(x: self.view.frame.width/2,y: self.view.frame.height/2)
                    l.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },
                completion: {(finished:Bool) in
                    //When completed, reset the animation
                    UIView.animate(withDuration:0.2,
                                   delay: -0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                                   animations: {
                                    l.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
                })
        }
    }
    
    @objc func EditLabel(longPress: UILongPressGestureRecognizer){
         if longPress.state == UIGestureRecognizerState.began {
            
        }
    }
    
    
    //Sets the current wordSet from the cycle
    func setCurrentWordSet(){
        currentWordSet = wordManager.returnWordSet()
        wordSetHeader.text = currentWordSet.name
    }
    
    
    //If we want to place every word in the set on the board
    func PlaceWords(){
        
        //For each word in the array
        for word in currentWordSet.wordList{
            //Create a label for it
            let l = UILabel()
            //Set the label properties
            l.backgroundColor = UIColor(red: 0xF0, green: 0xF0, blue: 0xC9, alpha: 1.0)
            l.text = "   \(word)   "
            //Set font size correctly if user is on iPad or iPhone
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                l.font = l.font.withSize(30)
            }else {
                 l.font = l.font.withSize(20)
            }
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
        
        if panGesture.state == UIGestureRecognizerState.changed{
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
            
        }
        
    }


}

