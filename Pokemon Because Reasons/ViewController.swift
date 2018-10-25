//  ViewController.swift
//  Pokemon Because Reasons
//
//  Created by Solomon Kieffer on 10/24/18.
//  Copyright © 2018 Phoenix Development. All rights reserved.

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var pokemonField: UITextField!
    @IBOutlet var dataField: UITextView!
    @IBOutlet var spriteView: UIImageView!
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchButton(UIButton())
        return true
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        guard let pokemonNameOrID = pokemonField.text, pokemonNameOrID != "" else {
            return
        }
        
        dataField.text = ""
        
        let requestURL = baseURL + pokemonNameOrID.lowercased().replacingOccurrences(of: " ", with: "_")
        
        let request = Alamofire.request(requestURL)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let stats = json["stats"].array
                
                print(stats)
                
                for stat in stats! {
                    self.dataField.text += "\(stat["stat"]["name"].stringValue.capitalized): \(stat["base_stat"])\n"
                }
                
                let sprite = json["sprites"]["front_default"].string
                let spriteURL = URL(string: sprite!)
                self.spriteView.sd_setImage(with: spriteURL, completed: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
