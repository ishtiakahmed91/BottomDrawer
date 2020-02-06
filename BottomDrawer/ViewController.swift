//
//  ViewController.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

extension UIView {
    /// Returns with a default string. Replacing NSStringFromClass method
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController {
    /// Returns with a default string. Replacing NSStringFromClass method
    static var identifier: String {
        return String(describing: self)
    }
}

class ViewController: UIViewController {
    
    var selectedItemId: String?
    
    @IBOutlet weak var drawerPositionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var cellTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var numberOfItemsSlider: UISlider!
    
    @IBAction func showDrawer(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BottomDrawer", bundle: nil)
        
        if let destinationVC = storyboard.instantiateViewController(withIdentifier: BottomDrawerViewController.identifier) as? BottomDrawerViewController,
            var destinationDS = destinationVC.router?.dataStore {
            
            for x in 1...Int(numberOfItemsSlider.value) {
                let item = BottomDrawer.Item(id: "\(x)", title: "Title \(x)", subtitle: "Subtitle \(x)")
                destinationDS.items.append(item)
            }
            
            var drawerPosition: BottomDrawerPosition
            var cellType: BottomDrawerCellType
            
            switch drawerPositionSegmentedControl.selectedSegmentIndex {
            case 0:
                drawerPosition = .dynamic
            case 1:
                drawerPosition = .center
            case 2:
                drawerPosition = .top
            default:
                drawerPosition = .dynamic
            }
            
            switch cellTypeSegmentedControl.selectedSegmentIndex {
            case 0:
                cellType = .title
            case 1:
                cellType = .verticalSubtitle
            case 2:
                cellType = .horizontalSubtitle
            default:
                cellType = .title
            }
            
            destinationDS.drawerPosition = drawerPosition
            destinationDS.cellType = cellType
            destinationDS.selectedItemId = selectedItemId ?? "\(0)"
            destinationVC.drawerItemSelectedCallBack = { selectedItemId in
                self.selectedItemId = selectedItemId
            }
            
            destinationVC.modalPresentationStyle = .overCurrentContext
            present(destinationVC, animated: true, completion: nil)
        }
    }
}
