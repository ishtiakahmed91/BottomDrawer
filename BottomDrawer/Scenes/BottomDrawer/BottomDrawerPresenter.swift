//
//  BottomDrawerPresenter.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

protocol BottomDrawerPresentationLogic {
    func presentItems(response: BottomDrawer.LoadItems.Response)
}

class BottomDrawerPresenter {
    weak var viewController: BottomDrawerDisplayLogic?
}

extension BottomDrawerPresenter: BottomDrawerPresentationLogic {
    func presentItems(response: BottomDrawer.LoadItems.Response) {
        DispatchQueue.main.async {[weak self] in
            let selectedRow = response.items.firstIndex(where: {$0.id == response.selectedItemId}) ?? 0
            let viewModel = BottomDrawer.LoadItems.ViewModel(items: response.items, cellType: response.cellType, selectedRow: selectedRow)
            self?.viewController?.displayItems(viewModel: viewModel)
        }
    }
}
