//
//  MainViewController.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextViewDelegate {
 
    @IBOutlet weak var emvDataTextVIew: UITextView!
    @IBOutlet weak var parseButton: UIButton!
    
    override func viewDidLoad() {
        designParseButton()
        addTapGesture()
    }
    
    
    //MARK: - UI design Functions
    func designParseButton() {
        parseButton.layer.cornerRadius = 8
        parseButton.layer.borderColor = UIColor.orange.cgColor
        parseButton.layer.borderWidth = 1
    }
    
    //MARK: - Helper Functions
    func addTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    // Dimiss the keyboard on tap
    @objc func dismissKeyboard() {
        //view.endEditing(true)
        emvDataTextVIew.resignFirstResponder()
    }
    // Dismiss the keyboard on Done key
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            emvDataTextVIew.resignFirstResponder()
            return false
        }
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "toDetailView" {
            if let detailVC = segue.destination as? TransactionDetailTableViewController {
                detailVC.transactionsArray = Parser.transactions
            }
        }
    }
    
    
    // MARK: - Actions
    @IBAction func parseButtonTapped(_ sender: Any) {
        guard let text = emvDataTextVIew.text else { return }

        Parser.parseTransactions(tlvString: text)
    }
    
    
} ///End
