//
//  ViewController.swift
//  Flashcards
//
//  Created by Jason Wahjudi on 10/13/18.
//  Copyright © 2018 Jason Wahjudi. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {


    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    var flashcards = [Flashcard]()
    
    var currentIndex = 0
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var prevButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSavedFlashcards()
        // Do any additional setup after loading the view, typically from a nib.
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Indonesia", answer: "Jakarta")
        } else {
            updateLabels()
            updateNextPrevButton()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
    }
    
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        backLabel.isHidden = true
        
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
        flashcards.append(flashcard)
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        updateNextPrevButton()
        updateLabels()
        updateNextPrevButton()
        saveAllFlashcardsToDisk()
    }
    
 
    
    func updateNextPrevButton(){
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateLabels()
        updateNextPrevButton()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButton()
    }
    
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.answer
        backLabel.text = currentFlashcard.question
    }
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcard saved to UserDeafult")
        
    }
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }

    
    
    

    
}

