//
//  MyViewController.swift
//  BarCodeScanner
//
//  Created by Дмитрий Кондратьев on 31.03.2021.
//

import UIKit

class MyViewController: UIViewController {

    @IBOutlet weak var typeBarCode: UITextField!
    @IBOutlet weak var barCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        let myDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = myDelegete.persistentContainer.viewContext
        let barCodeHistory = BarCodeHistory(context: context)
        
        barCodeHistory.typeBarCode = typeBarCode.text
        barCodeHistory.barCode = barCode.text
        
        myDelegete.saveContext()
        
        /*var barCodeHistory = BarCodeHistory()
        
        barCodeHistory.typeBarCode = "QRcode"
        barCodeHistory.barCode = "1234123421341234"
        */
    }

    @IBAction func readButton(_ sender: Any) {
        
        let myDelegete = UIApplication.shared.delegate as! AppDelegate
        let context = myDelegete.persistentContainer.viewContext
        //let barCodeHistory = BarCodeHistory(context: context)
        var barCodeHistorys: [BarCodeHistory] = []
        
        do {
            barCodeHistorys = try context.fetch(BarCodeHistory.fetchRequest())
            for bch in barCodeHistorys {
                print("Type: \(String(describing: bch.typeBarCode)), Bar code: \(String(describing: bch.barCode))")
            }
        } catch {
            debugPrint(error)
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
