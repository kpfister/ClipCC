//
//  TransactionDetailTableViewController.swift
//  ClipCC
//
//  Created by Karl Pfister on 3/12/18.
//  Copyright © 2018 Karl Pfister. All rights reserved.
//

import UIKit

class TransactionDetailTableViewController: UITableViewController {
    
    //var transactionsArray: [TransactionDetail] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Parser.sharedInstance.transactions.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionDetailCell", for: indexPath) as? TransActionDetailCell else { return UITableViewCell()}
        let transactionsArray = Parser.sharedInstance.transactions
        let transaction = transactionsArray[indexPath.row]
        cell.tagLabel.text = transaction.tag
        cell.tagDetailLabel.text = transaction.tagDetail
        cell.valueLabel.text = transaction.value

        return cell
    }

} /// End
