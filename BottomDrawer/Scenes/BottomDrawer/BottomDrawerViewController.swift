//
//  BottomDrawerViewController.swift
//
//  Created by Ishtiak Ahmed on 18.10.19.
//  Copyright © 2019 Ishtiak Ahmed. All rights reserved.
//

import UIKit

typealias DrawerItemSelectedCallBack = (String) -> Void

protocol BottomDrawerDisplayLogic: class {
    func displayItems(viewModel: BottomDrawer.LoadItems.ViewModel)
}

class BottomDrawerViewController: UIViewController {
    // MARK: Instance Properties
    var interactor: BottomDrawerBusinessLogic?
    var router: (NSObjectProtocol & BottomDrawerRoutingLogic & BottomDrawerDataPassing)?
    
    @IBOutlet weak var drawerTableView: UITableView!
    @IBOutlet weak var drawerVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    var drawerItemSelectedCallBack: DrawerItemSelectedCallBack?
    var selectedRow: Int?
    var drawerYPosition: CGFloat = 0.0
    var viewHight: CGFloat = 0.0
    var gestureFactor: CGFloat = 0.0
    var isSubtitleAvaiable: Bool?
    var axis: NSLayoutConstraint.Axis?
    var drawerPosition: BottomDrawerPosition?
    
    var items: [BottomDrawer.Item] = [] {
        didSet {
            drawerTableView.reloadData()
            calculateDrawerYPosition()
        }
    }
    
    var cellType: BottomDrawerCellType? {
        didSet {
            switch cellType {
            case .title, .none:
                isSubtitleAvaiable = false
                axis = .horizontal
            case .verticalSubtitle:
                isSubtitleAvaiable = true
                axis = .vertical
            case .horizontalSubtitle:
                isSubtitleAvaiable = true
                axis = .horizontal
            }
        }
    }
    
    // MARK: Object Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sceneSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sceneSetup()
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        viewHight = view.frame.height
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawerTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: drawerYPosition, right: 0)
    }
    
    // MARK: User events
    @IBAction func drawerScrolledToBottom(_ gestureRecognizer: UIPanGestureRecognizer) {
        if let gestureRecognizerView = gestureRecognizer.view {
            let translation = gestureRecognizer.translation(in: view)
            gestureRecognizerView.frame.origin.y +=  translation.y
            gestureRecognizer.setTranslation(.zero, in: view)
            
            if gestureRecognizer.state == .ended {
                let gestureLength = gestureRecognizerView.frame.origin.y - drawerYPosition
                let oneThirdOfDrawerLength = abs(viewHight - drawerYPosition)/3
                let isBounchBackToIntialDrawerYPosition = oneThirdOfDrawerLength > gestureLength
                let yPosition = isBounchBackToIntialDrawerYPosition ? drawerYPosition : viewHight
                
                UIView.animate(withDuration: 0.4,
                               delay: 0.0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 4.0,
                               options: .curveEaseInOut,
                               animations: ({
                                gestureRecognizerView.frame.origin.y =  yPosition
                                gestureRecognizer.setTranslation(.zero, in: self.view)
                               }), completion: {_ in
                                if !isBounchBackToIntialDrawerYPosition {
                                    self.dismissBottomDrawer()
                                }
                })
            }
        }
    }
    
}

// MARK: - Private Functions
private extension BottomDrawerViewController {
    func loadItems() {
        let request = BottomDrawer.LoadItems.Request()
        interactor?.loadItems(request: request)
    }
    
    func dismissBottomDrawer() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func calculateDrawerYPosition(){
        switch drawerPosition {
        case .center:
            drawerYPosition = viewHight/2
            gestureFactor = 1.2
        case .top:
            drawerYPosition = Constants.minimumSpaceBetweenDrawerTopAndViewTop
            gestureFactor = 1.5
        case .dynamic, .none:
            let cellHeight = cellType == .verticalSubtitle ? Constants.verticalCellHeight : Constants.horizontalCellHeight
            let drawerHeight = cellHeight * CGFloat(items.count) + Constants.additionalAreaOfDrawer
            
            if drawerHeight + Constants.minimumSpaceBetweenDrawerTopAndViewTop > viewHight {
                drawerYPosition = Constants.minimumSpaceBetweenDrawerTopAndViewTop
                gestureFactor = 1.3
            } else {
                drawerYPosition = viewHight - drawerHeight
                gestureFactor = 1.1
            }
        }
        topLayoutConstraint.constant = drawerYPosition
    }
    
}

// MARK: - UITableViewDelegate Logic
extension BottomDrawerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !items.isEmpty, let id = items[indexPath.row].id {
            drawerItemSelectedCallBack?("\(id)")
        }
        
        dismissBottomDrawer()
    }
}

// MARK: - UITableViewDataSource Logic
extension BottomDrawerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        guard items.indices.contains(row) else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: PrimaryTableViewCell.identifier, for: indexPath) as? PrimaryTableViewCell {
            if let axis = axis {
                cell.cellStackView.axis = axis
            }
            
            cell.titleLabel.text = items[row].title
            
            let textColor: UIColor = row == selectedRow ? .orange : .black
            cell.titleLabel.textColor = textColor
            
            if isSubtitleAvaiable == true {
                cell.subtitleLabel.textAlignment = axis == .horizontal ? .right : .left
                cell.subtitleLabel.text = items[row].subtitle
                cell.subtitleLabel.textColor = textColor
            } else {
                cell.subtitleLabel.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Display Logic
extension BottomDrawerViewController: BottomDrawerDisplayLogic {
    func displayItems(viewModel: BottomDrawer.LoadItems.ViewModel) {
        drawerPosition = viewModel.drawerPosition
        cellType = viewModel.cellType
        items = viewModel.items
        selectedRow = viewModel.selectedRow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            let indexPath = IndexPath(row: self?.selectedRow ?? 0, section: 0)
            self?.drawerTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
}
