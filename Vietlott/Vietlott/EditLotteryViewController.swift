//
//  EditLotteryViewController.swift
//  Camera&Number2
//
//  Created by CongTruong on 11/12/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class EditLotteryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lotteryTextField: UITextField!
    
    @IBOutlet weak var bottomMainView: NSLayoutConstraint!
    
    var isEdit = false
    
    var lotteryArray = [Lottery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // dark keyboard
        lotteryTextField.keyboardAppearance = .dark;
        
        // notify for show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(EditLotteryViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        // notify for hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(EditLotteryViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomMainView.constant += keyboardSize.size.height
        }
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            bottomMainView.constant -= keyboardSize.size.height
        }
    }
    
    @IBAction func addLottery(_ sender: Any) {
        if let text = lotteryTextField.text{
            if text.characters.count != 12 {
                // show alert notify error input
                if text.characters.count > 12 {
                    showAlert(title: "Message", message: "more than 12 characters\nretype input")
                } else {
                    
                    showAlert(title: "Message", message: "less than 12 characters\nretype input")
                }
                
                return
            }
            
            lotteryArray.insert(Lottery(lottery: text, time: Date().toString()), at: 0)
            tableView.reloadData()
            
            lotteryTextField.text = ""
        }
    }
    
    @IBAction func showAddLotteryView(_ sender: Any) {
        showInput()
    }
    
    @IBAction func hideKeyboardOnTap(_ sender: UITapGestureRecognizer) {
        if isEdit {
            hideInput()
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveLottery(_ sender: Any) {
        Constance.lotteryArrayHistory = lotteryArray + Constance.lotteryArrayHistory
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: animation show/hide input
    
    func showInput() {
        isEdit = true
        addView.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.addView.alpha = 1.0
        }, completion: {(e: Bool) -> Void in
            // show keyboard
            self.lotteryTextField.becomeFirstResponder()
        })
    }
    
    func hideInput() {
        isEdit = false
        
        lotteryTextField.text = ""
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.addView.alpha = 0.0
        }, completion: {(Bool) -> Void in
            self.addView.isHidden = true
        })
        
        // hide keyboard
        self.view.endEditing(true)
    }
    
    // MARK: show alert
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension EditLotteryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return lotteryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as! EditLotteryCell
        
        cell.lottery = lotteryArray[indexPath.section]
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 5))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
}

extension EditLotteryViewController: EditLotteryCellDelegate {
    func edit(cell: EditLotteryCell) {
        let str = cell.lotteryNumberLabel.text!
        lotteryTextField.text = str.removeWhitespace()
        
        showInput()
        
        lotteryArray.remove(at: (tableView.indexPath(for: cell)?.section)!)
        tableView.reloadData()
    }
}
