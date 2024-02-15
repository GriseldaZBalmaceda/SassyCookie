//
//  ViewController.swift
//  sassyFortune
//
//  Created by Griselda Balmaceda on 2/4/24.
//

import UIKit
import Lottie
class ViewController: UIViewController {

    @IBOutlet weak var messageFortune: UILabel!
    @IBOutlet weak var cookieButton: UIButton!
    private let animationView: LottieAnimationView = {
      let lottieAnimationView = LottieAnimationView(name: "cookie")
    
      return lottieAnimationView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageFortune.alpha = 0
        
    }
    
    @IBAction func cookieCracked(_ sender: Any) {
        fetchDataFromEndpoint()
        cookieButton.isHidden = true

        view.addSubview(animationView)
        animationView.frame = cookieButton.frame
        animationView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   animationView.leadingAnchor.constraint(equalTo: cookieButton.leadingAnchor),
                   animationView.trailingAnchor.constraint(equalTo: cookieButton.trailingAnchor),
                   animationView.topAnchor.constraint(equalTo: cookieButton.topAnchor),
                   animationView.bottomAnchor.constraint(equalTo: cookieButton.bottomAnchor),
               ])
        animationView.play { finished in
            if finished {
                   UIView.animate(withDuration: 0.5) {
                   } completion: { _ in
                       UIView.animate(withDuration: 1.0, animations: {
                                 self.messageFortune.alpha = 1 // Animate alpha to 1 (visible)
                             })
                   }
               }
        }
    }
    func fetchDataFromEndpoint() {
          // Perform network request asynchronously
        guard let url = URL(string:"http://127.0.0.1:8080/fortunes/1") else {
                print("Error: URL is nil")
                return
            }

      
        URLSession.shared.dataTask(with:url) { data, response, error in
              // Handle response or error
              if let error = error {
                  // Handle error
                  print("Error: \(error)")
                  DispatchQueue.main.async {
                      self.messageFortune.text = "Error: \(error.localizedDescription)"
                  }
                  return
              }

            if let data = data {
                     do {
                         let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                         if let text = json?["text"] as? String {
                             DispatchQueue.main.async {
                                 self.messageFortune.text = text
                             }
                             print(text)

                         } else {
                             // Handle missing or invalid 'text' field in the JSON
                             DispatchQueue.main.async {
                                 self.messageFortune.text = "Invalid response format"
                             }
                         }
                     } catch {
                         // Handle JSON parsing error
                         print("Error parsing JSON: \(error)")
                         DispatchQueue.main.async {
                             self.messageFortune.text = "Error parsing JSON"
                         }
                     }
                 }
          }.resume()
      }
    
}

