//
//  GeneratorController.swift
//  ViewGenerator
//
//  Created by Сабина on 3/7/20.
//  Copyright © 2020 Сабина. All rights reserved.
//

import UIKit

public protocol GeneratorDelegate {
    func createView(x: Int, y: Int, width: Int, height: Int, color: UIColor)
    func updateView(id: Int, x: Int, y: Int, width: Int, height: Int, color: UIColor)
    func deleteView(id: Int)
}

struct TappedViewModel {
    var id: Int
    var color: UIColor
    var x: Int
    var y: Int
    var width: Int
    var height: Int
}

class GeneratorController: UIViewController, UINavigationControllerDelegate {

    var delegate: GeneratorDelegate?
    var tappedView: TappedViewModel?
    var color: UIColor?
    
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet weak var yTextField: UITextField!
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let tappedView = tappedView {
            xTextField.text = "\(tappedView.x)"
            yTextField.text = "\(tappedView.y)"
            widthTextField.text = "\(tappedView.width)"
            heightTextField.text = "\(tappedView.height)"
            chooseColor(color: tappedView.color)
        } else {
            deleteButton.isEnabled = false
        }
        
    }
    
    @IBAction func handleSave(_ sender: Any) {
        
        let x = Int(xTextField.text!)
        let y = Int(yTextField.text!)
        let width = Int(widthTextField.text!)
        let height = Int(heightTextField.text!)
        
        if x == nil || y == nil || width == nil || height == nil || color == nil {
            
            let alert = UIAlertController(title: "Error", message: "Fill all text fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if tappedView != nil {
        
            delegate?.updateView(id: tappedView!.id, x: x!, y: y!, width: width!, height: height!, color: color!)
            navigationController?.popViewController(animated: true)
     
        } else {
            
            delegate?.createView(x: x!, y: y!, width: width!, height: height!, color: color!)
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    @IBAction func handleDelete(_ sender: Any) {
        if let tappedView = tappedView {
            delegate?.deleteView(id: tappedView.id)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func handleRed(_ sender: Any) {
        chooseColor(color: UIColor.red)
    }
    
    @IBAction func handleBlue(_ sender: Any) {
        chooseColor(color: UIColor.blue)
    }
    
    @IBAction func handlePurple(_ sender: Any) {
        chooseColor(color: UIColor.purple)
    }
    
    @IBAction func handleYellow(_ sender: Any) {
        chooseColor(color: UIColor.yellow)
    }
    
    func chooseColor(color: UIColor) {
        
        self.color = color
        
        var activeButton: UIButton?
    
        var deactiveButtons: [UIButton]?
   
        if color == UIColor.red {
            
            activeButton = redButton
            deactiveButtons = [blueButton, purpleButton, yellowButton]

        } else if color == UIColor.blue {
            
            activeButton = blueButton
            deactiveButtons = [redButton, purpleButton, yellowButton]

        } else if color == UIColor.purple {
            
            activeButton = purpleButton
            deactiveButtons = [redButton, blueButton, yellowButton]

        } else {
            
            activeButton = yellowButton
            deactiveButtons = [redButton, blueButton, purpleButton]
            
        }

        if activeButton!.backgroundColor != UIColor.systemBackground {
            
            activeButton!.setTitleColor(activeButton!.backgroundColor, for: .normal)
            activeButton!.backgroundColor = .systemBackground

            for deactiveButton in deactiveButtons! {
                
                if deactiveButton.backgroundColor == UIColor.systemBackground {
                    deactiveButton.backgroundColor = deactiveButton.titleColor(for: .normal)
                    deactiveButton.setTitleColor(.white, for: .normal)
                }
                
            }
        }
        
    }
    
}

