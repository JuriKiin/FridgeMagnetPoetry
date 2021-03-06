//
//  ViewController.swift
//  Fridge Magnet Poetry
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
    //View
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
    @IBAction func sharePoem(_ sender: Any) {
        //Turn off the settings view before we take a screenshot
        toggleSettingsView((Any).self)
        let canvasSize = CGSize(width: view.bounds.width, height: view.bounds.height-wordSetHeader.bounds.height-wordCollectionView.bounds.height)
        let image = self.view.takeScreenShot(rect: canvasSize)
        let textToShare = "Check out my poem made in Fridge Magnet Poetry!"
        let objectsToShare:[AnyObject] = [textToShare as AnyObject,image!]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.excludedActivityTypes = [UIActivityType.print]
        toggleSettingsView((Any).self)
        self.present(activityVC, animated: true, completion: nil)
    }
    
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
    
    //This toggles the settings view (backgroundImage, fontSize, share)
    @IBAction func toggleSettingsView(_ sender: Any) {
        settingsView.isHidden = !settingsView.isHidden
        isSettingsViewOpen = !isSettingsViewOpen
        view.bringSubview(toFront: settingsView)
    }
    
    //Loads the previous wordSet
    @IBAction func decrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step: -1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    //Loads the next wordSet
    @IBAction func incrementWordSet(_ sender: Any) {
        currentWordSet = wordManager.incrementWordSet(step: 1)
        setCurrentWordSet()
        wordCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.isHidden = true    //Hide the settings view
        setCurrentWordSet()         //Get our current wordset
        imagePicker.delegate = self //Setup image picker
        wordCollectionView.dataSource = self    //Setup word collection view
    }
    
//Helper Functions
    
    //Change settings based on iPad or iPhone platform
    func loadSettingsForDevice() {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            currentFontSize = 30
        }
        else{
            currentFontSize = 20
        }
    }
    
    //Add a word to the view.
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
            addPanGesture(label: newLabel)
            
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
    
    //This function clears all UILabels from the viewall
    // (Used when loading a new word set)
    func clearBoard() {
        for view in view.subviews {
            if view is UILabel{
                view.removeFromSuperview()
            }
        }
    }
    
    //Adds the pan gesture to the UILabel
    func addPanGesture(label: UILabel) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
        label.addGestureRecognizer(panGesture)
    }
    
    //What to do when we are dragging the word.
    @objc func doPanGesture(panGesture:UIPanGestureRecognizer) {
        //Get positions and update label position
        let label = panGesture.view as! UILabel
        let position = panGesture.location(in: view)
        label.center = position
        
        //This changes the icon in the top left corner
        if panGesture.state == UIGestureRecognizerState.changed {
             infoButton.setImage(UIImage(named: "trashIcon.png"), for: UIControlState.normal)
            label.backgroundColor = UIColor(white: 1, alpha: 0.5)
        }
        else{
            infoButton.setImage(UIImage(named: "infoIcon"), for: UIControlState.normal)
             label.backgroundColor = UIColor(white: 1, alpha: 1.0)
        }
        
        //If we release the word and it's not on the canvas, move it up so its at the bottom of the canvas
        if panGesture.state == UIGestureRecognizerState.ended && (position.x > infoButton.frame.minX && position.y < infoButton.frame.maxY) {
            label.removeFromSuperview()
            wordArray.remove(at: wordArray.index(of: label)!)
        }
        if panGesture.state == UIGestureRecognizerState.ended && (position.y > wordSetHeader.frame.minY) {
            label.center = CGPoint(x: label.center.x, y: wordSetHeader.frame.minY - 25)
        }
    }
}

//Extensions

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
    
    func returnWordArray() -> [UILabel] {
        return wordArray
    }
    
}

extension UIView {
    //Takes a screenshot of a given canvas size
    func takeScreenShot(rect: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}





