//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {
    
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
    }

    
}

// MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    
    func didUpdateWeather(_ coinManager: CoinManager, rate: String, currency: String) {
      
        DispatchQueue.main.async {
            
            self.bitcoinLabel.text = rate
            self.currencyLabel.text = currency
            //self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let selectedCurrency = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: selectedCurrency)
        
        //currencyLabel.text = selectedCurrency
    }

    
}
