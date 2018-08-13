//
//  Settings.swift
//  numberTiles
//
//  Created by Josh Jaslow on 7/25/17.
//  Copyright © 2017 Jaslow Enterprises. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import CoreData

class settings: SKScene, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var settingsVC: GameViewController?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var images: [SelectedImage] = []
    
    func getData() {
        do {
            images = try context.fetch(SelectedImage.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
    }
    
    func addAndSaveData(data: NSData) {
        //Add using CD
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let image = SelectedImage(context: context) // Link Task & Context
        image.imageData = data
        
        // Save the data to coredata
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
//    Deleting using CD
//    context.delete(task)
//    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
    var imageButtonBorder = SKSpriteNode()
    var imageButton = SKSpriteNode()
    var imageText = SKLabelNode()
    var imageDisplay = SKSpriteNode()
    
    var backButton = SKSpriteNode()
    var backText = SKLabelNode()
    
    override func didMove(to view: SKView) {
        imageButtonBorder = self.childNode(withName: "imageButtonBorder") as! SKSpriteNode
        imageButton = self.childNode(withName: "imageButton") as! SKSpriteNode
        imageText = self.childNode(withName: "imageText") as! SKLabelNode
        imageDisplay = self.childNode(withName: "imageDisplay") as! SKSpriteNode
        
        backButton = self.childNode(withName: "backButton") as! SKSpriteNode
        backText = self.childNode(withName: "backText") as! SKLabelNode
        
        getData()
        if let image = images.popLast() {
            let tempy:UIImage = UIImage(data: image.imageData! as Data)!
            imageDisplay.texture = SKTexture(image: tempy)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var location: CGPoint? = nil
        for touch in touches {
            location = touch.location(in: self)
        }
        if imageButtonBorder.contains(location!) {
            imageButtonBorder.run(pulse)
            imageButton.run(pulse)
            imageText.run(pulse)
            selectImageFromPhotoLibrary()
        }
        else if backButton.contains(location!) {
            
            backButton.run(pulse)
            backText.run(pulse)
            let transition: SKTransition = SKTransition.fade(withDuration: 0.75)
            transition.pausesOutgoingScene = false
            let scene: SKScene = Menu(fileNamed: "Menu")!
            if deviceIsIpad() {
                scene.scaleMode = .aspectFit
            }
            else {
                scene.scaleMode = .aspectFill
            }
            self.view?.presentScene(scene, transition: transition)
        }
    }
    
    // MARK: UIImage Delegate and Selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //Closes photo album is cancel is pressed
        // Dismiss the picker if the user canceled.
        self.settingsVC?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //Used to access photo album
        // The info dictionary contains multiple representations of the image, and this uses the original.
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            // Set photoImageView to display the selected image.
            imageDisplay.texture = SKTexture(image: editedImage)
            let imageData: NSData = UIImagePNGRepresentation(editedImage)! as NSData
            addAndSaveData(data: imageData)
            //textureArr = splitImage(numPieces: 4, original: SKTexture(image: editedImage!))
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Set photoImageView to display the selected image.
            imageDisplay.texture = SKTexture(image: originalImage)
            let imageData: NSData = UIImagePNGRepresentation(originalImage)! as NSData
            addAndSaveData(data: imageData)
            //textureArr = splitImage(numPieces: 4, original: SKTexture(image: originalImage!))
        }
        else {
            print("Something went wrong with image selection")
        }
        
        // Dismiss the picker.
        self.settingsVC?.dismiss(animated: true, completion: nil)
    }
    
    func selectImageFromPhotoLibrary() { //**Run this function to pick photo**
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        //Create an action sheet button to manage buttons for image source
        let actionSheet = UIAlertController(title: "Image Source", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.settingsVC?.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                let camNotAvailable = UIAlertController(title: "Camera Not Available", message: "", preferredStyle: UIAlertControllerStyle.alert)
                camNotAvailable.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.settingsVC?.present(camNotAvailable, animated: true, completion: nil)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            // Allow an image to be used
            imagePickerController.sourceType = .photoLibrary
            //Show image
            self.settingsVC?.present(imagePickerController, animated: true, completion: nil)

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //Show actionSheet
        self.settingsVC?.present(actionSheet, animated: true, completion: nil)

    }
    
    func splitImage(numPieces: Int, original: SKTexture) -> [SKTexture] {
        var images: [SKTexture] = []
        let sizeOfCropX = Int(original.size().width / CGFloat(numPieces))
        let sizeOfCropY = Int(original.size().height / CGFloat(numPieces))
        
        for a in 0..<numPieces {
            for b in 0..<numPieces {
                let tempImage = original
                let rect = CGRect(x: (b * sizeOfCropX), y: (a * sizeOfCropY), width: sizeOfCropX, height: sizeOfCropY)
                images.append(SKTexture(rect: rect, in: tempImage))
            }
        }
        
        return images
    }
}

//MARK: - Global
var textureArr: [SKTexture] = []
