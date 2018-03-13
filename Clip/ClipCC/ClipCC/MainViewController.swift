//
//  MainViewController.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //let parser = Parser()
    //var transactionsArray: [TransactionDetail] = []

    @IBOutlet weak var emvDataTextVIew: UITextView!
    @IBOutlet weak var parseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
 
    @IBAction func parseButtonTapped(_ sender: Any) {
        guard let text = emvDataTextVIew.text else { return }

        Parser.parseTransactions(tlvString: text)
        
        
    }
}
