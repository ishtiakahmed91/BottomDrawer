//
//  ViewController.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var selectedItemId: String?
    
    @IBAction func showDrawer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BottomDrawer", bundle: nil)
        
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: BottomDrawerViewController.identifier) as? BottomDrawerViewController,
            var destinationDS = destinationVC.router?.dataStore {
            
            for x in 1...100 {
                let item = BottomDrawer.Item(id: "\(x)", title: "Title \(x)", subtitle: "Subtitle \(x)")
                destinationDS.items.append(item)
            }
          
            destinationDS.cellType = .horizontalSubtitle
            destinationDS.selectedItemId = selectedItemId ?? "\(0)"
            destinationVC.drawerItemSelectedCallBack = { selectedItemId in
                self.selectedItemId = selectedItemId
            }
            
            destinationVC.modalPresentationStyle = .overCurrentContext
            present(destinationVC, animated: true, completion: nil)
        }
    }
}
