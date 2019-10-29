//
//  BottomDrawer+SceneSetup.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

extension BottomDrawerViewController {
    func sceneSetup() {
        let viewController = self
        let interactor = BottomDrawerInteractor()
        let presenter = BottomDrawerPresenter()
        let router = BottomDrawerRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
}
