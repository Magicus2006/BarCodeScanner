//
//  HistoryBarCodeTableViewController.swift
//  BarCodeScanner
//
//  Created by Дмитрий Кондратьев on 30.03.2021.
//

import UIKit

class HistoryBarCodeTableViewController: UITableViewController {

    var barCodeHistory: [BarCodeHistory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return barCodeHistory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarCodeCell", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        let type = barCodeHistory[indexPath.row].typeBarCode
        let barCode = barCodeHistory[indexPath.row].barCode
        label.text = "\(type!): \(barCode!)"
        return cell
    }
    
    func fetchData() {
        let myDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = myDelegete.persistentContainer.viewContext
        
        do {
            barCodeHistory = try context.fetch(BarCodeHistory.fetchRequest())
            
        } catch {
            debugPrint(error)
        }
    }
    

}
