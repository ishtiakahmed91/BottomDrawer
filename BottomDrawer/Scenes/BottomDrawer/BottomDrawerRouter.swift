//
//  BottomDrawerRouter.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

protocol BottomDrawerDataPassing {
    var dataStore: BottomDrawerDataStore? { get }
}

class BottomDrawerRouter: NSObject, BottomDrawerDataPassing {
    weak var viewController: BottomDrawerViewController?
    var dataStore: BottomDrawerDataStore?
}

// MARK: - Private Functions
private extension BottomDrawerRouter {
//    func navigateToSomewhere(source: BottomDrawerViewController, destination: SomewhereViewController) {
//        source.show(destination, sender: nil)
//    }
//
//    func passDataToSomewhere(source: BottomDrawerDataStore, destination: inout SomewhereDataStore) {
//        destination.name = source.name
//    }
}

@objc protocol BottomDrawerRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

extension BottomDrawerRouter: BottomDrawerRoutingLogic {
//    func routeToSomewhere(segue: UIStoryboardSegue?) {
//        if let segue = segue,
//            let destinationVC = segue.destination as? SomewhereViewController,
//            var destinationDS = destinationVC.router?.dataStore {
//
//            passDataToSomewhere(source: dataStore, destination: &destinationDS)
//        } else {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as? SomewhereViewController,
//                var destinationDS = destinationVC.router?.dataStore {
//                passDataToSomewhere(source: dataStore, destination: &destinationDS)
//                navigateToSomewhere(source: viewController, destination: destinationVC)
//            }
//        }
//    }
}
