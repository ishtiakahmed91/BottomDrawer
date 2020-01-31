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
private extension BottomDrawerRouter {}

@objc protocol BottomDrawerRoutingLogic {}

extension BottomDrawerRouter: BottomDrawerRoutingLogic {}
