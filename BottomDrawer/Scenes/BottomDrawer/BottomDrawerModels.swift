//
//  BottomDrawerModels.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

enum BottomDrawer {
    
    enum LoadItems {
        struct Request { }
        
        struct Response {
            let items: [BottomDrawer.Item]
            let drawerPosition: BottomDrawerPosition
            let cellType: BottomDrawerCellType
            let selectedItemId: String
        }
        
        struct ViewModel {
            let items: [BottomDrawer.Item]
            let drawerPosition: BottomDrawerPosition
            let cellType: BottomDrawerCellType
            let selectedRow: Int
        }
    }
    
    struct Item {
        let id: String?
        let title: String?
        let subtitle: String?
    }
}

enum BottomDrawerCellType {
    case title
    case horizontalSubtitle
    case verticalSubtitle
}

enum BottomDrawerPosition {
    case dynamic
    case center
    case top
}
