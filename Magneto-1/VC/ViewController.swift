//
//  ViewController.swift
//  Magneto-1
//
//  Created by Juri Kiin on 2/4/18.
//  Copyright © 2018 Juri Kiin. All rights reserved.

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {

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
        view.bringSubview(toFront: settingsView)
    }
    
    
    @IBAction func decrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step: -1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    @IBAction func incrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step: 1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettingsForDevice()
        settingsView.isHidden = true
        
        setCurrentWordSet()
        
        imagePicker.delegate = self
        wordCollectionView.dataSource = self
        
        //This loads all of the words on the screen for the active wordset.
        //PlaceWords()
        
    }
    
    
    //FUNCTIONS
    
    func loadSettingsForDevice() {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            currentFontSize = 30
        }
        else{
            currentFontSize = 20
        }
    }
    
    @objc func addWord(press: UITapGestureRecognizer) {
        
        if isSettingsViewOpen == false {
            let newLabel = UILabel()
            //Set the label properties
            let cell = press.view as! CustomCollectionViewCell
            newLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            newLabel.text = "   \(cell.wordLabel.text!)   "
            newLabel.font = newLabel.font.withSize(CGFloat(currentFontSize))
            newLabel.layer.borderColor = UIColor.black.cgColor
            newLabel.layer.borderWidth = 1.0
            newLabel.sizeToFit()
            wordArray.append(newLabel)
            view.addSubview(newLabel)
            //Make it interactable
            newLabel.isUserInteractionEnabled = true
            //Add a pan gesture to the label
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
            newLabel.addGestureRecognizer(panGesture)
            
            //Get the position of the longPress to animate from there.
            let position = press.location(in: view)
            newLabel.center = position
            
            //Add the placing word animation
            UIView.animate(withDuration:0.5,
                delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                animations: {
                    newLabel.center = CGPoint(x: self.view.frame.width/2,y: self.view.frame.height/2)
                    newLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                },
                completion: {(finished:Bool) in
                    //When completed, reset the animation
                    UIView.animate(withDuration:0.2,
                                   delay: -0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [],
                                   animations: {
                                    newLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    })
                })
        }
    }
    
    //Sets the current wordSet from the cycle
    func setCurrentWordSet() {
        currentWordSet = wordManager.returnWordSet()
        wordSetHeader.text = currentWordSet.name
    }
    
    
    //If we want to place every word in the set on the board
    func placeWords() {
        
        //For each word in the array
        for word in currentWordSet.wordList {
            //Create a label for it
            let newLabel = UILabel()
            //Set the label properties
            newLabel.backgroundColor = UIColor(red: 0xF0, green: 0xF0, blue: 0xC9, alpha: 1.0)
            newLabel.text = "   \(word)   "
            //Set font size correctly if user is on iPad or iPhone
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
                newLabel.font = newLabel.font.withSize(30)
            }else {
                 newLabel.font = newLabel.font.withSize(20)
            }
            newLabel.layer.borderColor = UIColor.black.cgColor
            newLabel.layer.borderWidth = 1.0
            newLabel.sizeToFit()
            wordArray.append(newLabel)
            view.addSubview(newLabel)
            //Make it interactable
            newLabel.isUserInteractionEnabled = true
            //Add a pan gesture to the label
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
            newLabel.addGestureRecognizer(panGesture)
        }
        organizeWords()
    }
    
    func organizeWords() {
        
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
        for i in 1 ..< wordArray.count {
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
    func clearBoard() {
        for view in view.subviews {
            if view is UILabel{
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func doPanGesture(panGesture:UIPanGestureRecognizer) {
        //Get positions and update label position
        let label = panGesture.view as! UILabel
        let position = panGesture.location(in: view)
        label.center = position
        
        if panGesture.state == UIGestureRecognizerState.changed {
             infoButton.setImage(UIImage(named: "trashIcon.png"), for: UIControlState.normal)
            label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        }
        else{
            infoButton.setImage(UIImage(named: "infoIcon"), for: UIControlState.normal)
             label.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        
        if panGesture.state == UIGestureRecognizerState.ended && (position.x > infoButton.frame.minX && position.y < infoButton.frame.maxY) {
            label.removeFromSuperview()
            wordArray.remove(at: wordArray.index(of: label)!)
        }
        if panGesture.state == UIGestureRecognizerState.ended && (position.y > wordSetHeader.frame.minY) {
            label.center = CGPoint(x: label.center.x, y: wordSetHeader.frame.minY - 25)
        }
        
    }


}


extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        backgroundImageView.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    //Collection view delegate functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentWordSet.wordList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wordCollectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.wordLabel.text = currentWordSet.wordList[indexPath.row]
        cell.wordLabel.layer.borderColor = UIColor.black.cgColor
        cell.wordLabel.layer.borderWidth = 2.0
        
        //Add touch hold recognizer
        let pressRecognizer = UITapGestureRecognizer(target: self, action: #selector(addWord(press:)))
        cell.addGestureRecognizer(pressRecognizer)
        
        return cell
    }
}





