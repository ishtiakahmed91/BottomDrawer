# BottomDrawerExample

This is an example application using clean swift to replicate the bottom drawer behaviour in iOS. 

Configuration: 
- The bottom drawer can be positioned to the centre or the top of the view.  
- The drawer can also be positioned dynamically according to the number of cells. If cell height * number of cells > view height, the drawer will be positioned to Top.
- The cell data are represented in three ways: single title, title and vertical subtitle, title and horizontal subtitle. 

How to:
drawerPosition, cellType, selectedItemId should be added in destinationVC.router.dataStore before presenting the bottom drawer view controller modally. 


Available cell type and drawer position: 
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
