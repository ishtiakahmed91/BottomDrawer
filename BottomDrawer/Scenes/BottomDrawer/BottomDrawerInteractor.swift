//
//  BottomDrawerInteractor.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

protocol BottomDrawerDataStore {
    var cellType: BottomDrawerCellType { get set }
    var items: [BottomDrawer.Item] { get set }
    var selectedItemId: String? { get set }
}

protocol BottomDrawerBusinessLogic {
    func loadItems(request: BottomDrawer.LoadItems.Request)
}

class BottomDrawerInteractor: BottomDrawerDataStore {
    
    // MARK: Instance Properties
    var presenter: BottomDrawerPresentationLogic?
    var cellType: BottomDrawerCellType = .title
    var items: [BottomDrawer.Item] = []
    var selectedItemId: String?
}

extension BottomDrawerInteractor: BottomDrawerBusinessLogic {
    func loadItems(request: BottomDrawer.LoadItems.Request) {
        if let selectedItemId = selectedItemId {
            let response = BottomDrawer.LoadItems.Response(items: items, cellType: cellType, selectedItemId: selectedItemId)
            presenter?.presentItems(response: response)
        }
    }
}
