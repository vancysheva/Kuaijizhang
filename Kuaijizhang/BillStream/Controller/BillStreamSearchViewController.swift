//
//  BillStreamSearchViewController.swift
//  Kuaijizhang
//
//  Created by 范伟 on 16/3/7.
//  Copyright © 2016年 范伟. All rights reserved.
//

import UIKit

class BillStreamSearchViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let duration = Double(Float(UINavigationControllerHideShowBarDuration))
    let translationTx = CGFloat(25)
    let blackColorForHalTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    let blackColorForTransparent = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    lazy var textFieldAgent = TextFieldAgent()
    
    var billStreamViewModel: BillStreamViewModel?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        config()
        
        billStreamViewModel?.addNotification("BillStreamSearchViewController", notificationHandler: { (transactionState, dataChangedType, indexPath, userInfo) -> Void in
            if let ip = userInfo?["indexPath"] as? NSIndexPath {
                self.tableView.deleteRowsAtIndexPaths([ip], withRowAnimation: .Automatic)
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        show()
    }
    

    // MARK: - Methods
    
    private func config() {
        
        searchTextField.delegate = textFieldAgent
        bodyView.hidden = true
        searchView.layer.cornerRadius = 5
        setState()
        
        textFieldAgent.addTextFieldTextDidChangeNotification({[unowned self] (notification) -> Void in
            if let keyWord = self.searchTextField.text where keyWord.trim() != "" {
                self.bodyView.hidden = false
                self.loadData(keyWord)
            } else {
                self.bodyView.hidden = true
            }
        })
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let point = touches.first?.locationInView(bodyView) where CGRectContainsPoint(bodyView.bounds, point) {
            performSegueWithIdentifier("unwindToBillStreamSegue", sender: self)
        }
    }

    func show() {
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.headerView.alpha = 1
            self.searchView.transform = CGAffineTransformIdentity
            self.cancelButton.transform = CGAffineTransformIdentity
            self.view.backgroundColor = self.blackColorForHalTransparent
            }, completion: { b in
                self.searchTextField.becomeFirstResponder()
        })

    }

    
    func hide() {
        searchTextField.resignFirstResponder()
        UIView.animateWithDuration(duration) {
            self.setState()
        }
    }

    func setState() {
        headerView.alpha = 0
        view.backgroundColor =  blackColorForTransparent
        searchView.transform = CGAffineTransformMakeTranslation(translationTx, 0)
        cancelButton.transform = CGAffineTransformMakeTranslation(translationTx, 0)
    }
    
    func loadData(keyWord: String) {
        
        billStreamViewModel?.getBillsBy(keyWord)
        tableView.reloadData()
        totalIncomeLabel.text = "\(billStreamViewModel!.totalSearchBillsIncome)"
        totalExpenseLabel.text = "\(billStreamViewModel!.totalSearchBillsExpense)"
    }
}

extension BillStreamSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  billStreamViewModel?.searchBills?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let data = billStreamViewModel?.searchBills?[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier(data?.comment?.isEmpty ?? false ? "cellWithoutComment" : "cellWithComment", forIndexPath: indexPath) as! BillStreamSearchViewCell
        cell.data = data
        return cell
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! BillStreamSearchViewCell
            if let index = cell.data?.index {
                billStreamViewModel?.deleteSearchBillAt(index, indexPath: indexPath)
            }
        }
    }
}
