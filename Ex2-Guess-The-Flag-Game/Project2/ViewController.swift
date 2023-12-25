//
//  ViewController.swift
//  Project2
//
//  Created by Mahmud CIKRIK on 25.09.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var buttonPressCount = 0
    var correctScore = 0
    var wrongScore = 0
    

    
    override func viewDidLoad() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreTapped))
        

        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        /*
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
         Bunun yerine
         */
        
        countries += ["estonia", "nigeria", "spain", "monaco", "ireland", "us", "uk", "russia", "poland", "germany"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
   
  
   
        
        
        askQuestion()
        
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2 )
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
      

        
        title = countries[correctAnswer].uppercased() + " score is " + String(score)
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String?
        
        
        buttonPressCount += 1
          if buttonPressCount == 10 {
             let ac2 = UIAlertController(title: "Game Over", message: "Your Final Score is \(score) \n Correct answer: \(correctScore) / 10 ", preferredStyle: .alert)
              present (ac2, animated: true)
              
              ac2.addAction(UIAlertAction(title: "Try Again", style: .default, handler: askQuestion))
              
          } else {
              
              if sender.tag == correctAnswer {
                  title = "Correct"
                  score += 1
                  correctScore += 1
                  let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
                  
                  ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                  
                  present (ac, animated: true)
                
              } else {
                  title = "Wrong"
                  score -= 1
                  wrongScore += 1
                  
                  let ac3 = UIAlertController(title: title, message: "No! That's the flag of \(countries[sender.tag].uppercased())", preferredStyle: .alert)
                  
                  ac3.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
                  
                  present (ac3, animated: true)
                  
              }
              
              
              
          }
            
    }
    
  
    
    @objc func scoreTapped () {

        let scoreBoard = "Your score: \(score)"
        
        let vc = UIActivityViewController(activityItems: [scoreBoard], applicationActivities: [])
        present(vc, animated: true)
    }
    
}

// alertler çıkış şart dışarı tıklayınca çıkmıyor
// ask question yerine sıfırlama özelliği koy.
// let ac yerine var olur mu?
