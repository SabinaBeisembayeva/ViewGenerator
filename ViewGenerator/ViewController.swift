//
//  ViewController.swift
//  ViewGenerator
//
//  Created by Сабина on 3/6/20.
//  Copyright © 2020 Сабина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func handleDrag(_ sender: UIPanGestureRecognizer){
        if let dragView = sender.view {
            self.view.bringSubviewToFront(dragView)
            let translation = sender.translation(in: self.view)
            dragView.center = CGPoint(x: dragView.center.x + translation.x, y: dragView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    @objc func handleZoom(_ sender: UIPinchGestureRecognizer) {
        if let zoomView = sender.view {
            self.view.bringSubviewToFront(zoomView)
            zoomView.transform = zoomView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if let tappedView = sender.view {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "generator") as! GeneratorController
            vc.delegate = self
            vc.tappedView = TappedViewModel(id: tappedView.tag, color: tappedView.backgroundColor!, x: Int(tappedView.frame.minX), y: Int(tappedView.frame.minY), width: Int(tappedView.frame.width), height: Int(tappedView.frame.height))
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "generator"{
            let vc = segue.destination as! GeneratorController
            vc.delegate = self
        }
    }

}

extension ViewController: GeneratorDelegate {
    
    func updateView(id: Int, x: Int, y: Int, width: Int, height: Int, color: UIColor) {
        if let updateView = view.viewWithTag(id) {
            updateView.backgroundColor = color
            updateView.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }

    func deleteView(id: Int) {
        if let deleteView = view.viewWithTag(id) {
            deleteView.removeFromSuperview()
        }
    }
 
    func createView(x: Int, y: Int, width: Int, height: Int, color: UIColor) {
        let newView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        newView.backgroundColor = color
        newView.isUserInteractionEnabled = true
        newView.tag = UUID().uuidString.hashValue 
  
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        newView.addGestureRecognizer(dragGesture)

        let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom(_:)))
        newView.addGestureRecognizer(zoomGesture)
  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        newView.addGestureRecognizer(tapGesture)
        
        view.addSubview(newView)
        
    }
    
}
