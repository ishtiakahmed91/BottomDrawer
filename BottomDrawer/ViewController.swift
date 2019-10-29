//
//  ViewController.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func showDrawer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BottomDrawer", bundle: nil)
        
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: BottomDrawerViewController.identifier) as? BottomDrawerViewController,
            var destinationDS = destinationVC.router?.dataStore {
            
            for a in 1...22 {
                let item = BottomDrawer.Item(id: "\(a)", title: "Title \(a)", subtitle: "Sub title one")
                destinationDS.items.append(item)
            }
          
            destinationDS.cellType = .horizontalSubtitle
            destinationDS.selectedItemId = "\(13)"
            destinationVC.modalPresentationStyle = .overCurrentContext
            present(destinationVC, animated: true, completion: nil)
        }
    }
    
}

