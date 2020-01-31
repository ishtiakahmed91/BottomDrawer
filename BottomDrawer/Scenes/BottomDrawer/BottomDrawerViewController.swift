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
    var cellType: BottomDrawerCellType = .title
    var selectedRow: Int?
    var drawerPositionMiddle: CGFloat = 0.0
    
    var items: [BottomDrawer.Item] = [] {
        didSet {
            drawerTableView.reloadData()
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
        drawerPositionMiddle = view.frame.height/2
        topLayoutConstraint.constant = drawerPositionMiddle
        loadItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        drawerTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: drawerPositionMiddle, right: 0)
    }
    
    // MARK: User events
    @IBAction func drawerScrolledToBottom(_ gestureRecognizer: UIPanGestureRecognizer) {
        if let gestureRecognizerView = gestureRecognizer.view {
            let translation = gestureRecognizer.translation(in: self.view)            
            gestureRecognizerView.frame.origin.y +=  translation.y
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            
            if gestureRecognizer.state == .ended {
                let isBounchBackToIntialDrawerYPosition =  gestureRecognizerView.frame.origin.y < drawerPositionMiddle * 1.5
                let yPosition = isBounchBackToIntialDrawerYPosition ? drawerPositionMiddle : view.frame.height
                
                UIView.animate(withDuration: 0.4,
                               delay: 0.0,
                               usingSpringWithDamping: 0.5,
                               initialSpringVelocity: 4.0,
                               options: .curveEaseInOut,
                               animations: ({
                                gestureRecognizerView.frame.origin.y =  yPosition
                                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
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
        
        let textColor: UIColor = row == selectedRow ? .red : .black
        
        switch cellType {
        case .title:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell {
                cell.titleLabel.text = items[row].title
                cell.titleLabel.textColor = textColor
                return cell
            }
        case .verticalSubtitle:
            if let cell = tableView.dequeueReusableCell(withIdentifier: VerticalSubtitleTableViewCell.identifier, for: indexPath) as? VerticalSubtitleTableViewCell {
                cell.titleLabel.text = items[row].title
                cell.subtitleLabel.text = items[row].subtitle
                cell.titleLabel.textColor = textColor
                cell.subtitleLabel.textColor = textColor
                return cell
            }
        case .horizontalSubtitle:
            if let cell = tableView.dequeueReusableCell(withIdentifier: HorizontalSubtitleTableViewCell.identifier, for: indexPath) as? HorizontalSubtitleTableViewCell {
                cell.titleLabel.text = items[row].title
                cell.subtitleLabel.text = items[row].subtitle
                cell.titleLabel.textColor = textColor
                cell.subtitleLabel.textColor = textColor
                return cell
            }
        }
        return UITableViewCell()
    }
}

// MARK: - Display Logic
extension BottomDrawerViewController: BottomDrawerDisplayLogic {
    func displayItems(viewModel: BottomDrawer.LoadItems.ViewModel) {
        items = viewModel.items
        cellType = viewModel.cellType
        selectedRow = viewModel.selectedRow
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
            let indexPath = IndexPath(row: self?.selectedRow ?? 0, section: 0)
            self?.drawerTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
}

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
