//
//  ViewController.swift
//  Project2
//
//  Created by Mahmud CIKRIK on 25.09.2023.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var buttonPressCount = 0
    var correctScore = 0
    var wrongScore = 0
    var PreviousScore = 0
    var currentAnimation = 0

    
    override func viewDidLoad() {
            
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreTapped))
        
        super.viewDidLoad()
        loadScore()
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // 5 saniye sonra bu blok çalışacak
            self.sendBackgroundNotification()
        }
        
        
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2 )
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " Score: " + String(score) + " TopScore: \(PreviousScore)"
        
    }
    
    func restartGame(action: UIAlertAction! = nil) {
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2 )
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " Score: " + String(score) + " TopScore: \(PreviousScore)"
        
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String?
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1, animations: {
            
            switch self.currentAnimation {
            case 0:
                sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            default:
                break
            }
        }) { finished in
            
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                
                switch self.currentAnimation {
                case 0:
                    sender.transform = .identity
                default:
                    break
                }
            }) }
        
        // animasyonun bitmesini bekledikten sonra
                
                buttonPressCount += 1
                if buttonPressCount == 10 {
                    buttonPressCount = 0
                    // load previousScore
                    loadScore()
                    if score > PreviousScore {
                        PreviousScore = score
                        saveScore()
                        let ac2 = UIAlertController(title: "Congrulations! You're the Champion", message: "Your Final Score is \(score) \n Correct answer: \(correctScore) / 10 ", preferredStyle: .alert)
                        present (ac2, animated: true)
                        
                        ac2.addAction(UIAlertAction(title: "Try Again", style: .default, handler: restartGame))
                        
                    } else {
                        let ac2 = UIAlertController(title: "Game Over", message: "Your Final Score is \(score) \n Correct answer: \(correctScore) / 10 ", preferredStyle: .alert)
                        present (ac2, animated: true)
                        
                        ac2.addAction(UIAlertAction(title: "Try Again", style: .default, handler: restartGame))
                    }
                    
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
    
    func saveScore() {
        
        UserDefaults.standard.set(PreviousScore, forKey: "prev")
        
    }
    
    func loadScore() {
        
        if let savedScore = UserDefaults.standard.integer(forKey: "prev") as Int? {
            
            PreviousScore = savedScore
        }
        
    }
    
    func sendBackgroundNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        // Bildirim izinlerini iste
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // İzinler alındığında bildirim içeriğini oluştur
                let content = UNMutableNotificationContent()
                content.title = "Pratik Yapma Vakti!"
                content.body = "Biraz zihnimizi çalıştıralım."
                content.sound = .default
                
                // Bildirimi göndermek için bir tetikleyici oluştur
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
                // Örneğin, 5 saniye sonra bir kez tetiklenmesi için
                
                // Bildirimi oluştur
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // Bildirimi gönder
                center.add(request) { (error) in
                    if let error = error {
                        print("Arkaplan bildirimi gönderme hatası: \(error)")
                    } else {
                        print("Arkaplan bildirimi başarıyla gönderildi.")
                    }
                }
            } else {
                print("Kullanıcı bildirimlere izin vermedi.")
            }
        }
    }
    
}

// alertler çıkış şart dışarı tıklayınca çıkmıyor
// ask question yerine sıfırlama özelliği koy.
// let ac yerine var olur mu?
