//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate{
    
    func didUpdateWeather(_ coinManager : CoinManager, rate : String, currency : String)
    func didFailWithError(error : Error)
    
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "BA60382D-4AE2-4C97-A188-DE35C722E3AE"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency : String){
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        performRequest(with: urlString)
        
    }

    
    func performRequest(with urlString: String){
        
        //Step-1 Create a URL
        if let url = URL(string: urlString){
            
            //Step-2 Create a URLSession
            let session = URLSession(configuration: .default)
            
            //Step-3 Give URL Session a Task
            
            let task = session.dataTask(with: url) { data, response, error in // closure
                
                if error != nil{
                    
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    let str = String.init(data: data!, encoding: .utf8)
                  //  print(str)
                    if let coin = self.parseJSON(safeData){
                        
                        
                        let rateRound = String(format: "%.2f", coin.rate)
                
                        self.delegate?.didUpdateWeather(self, rate: rateRound, currency: coin.asset_id_quote)
                    }
                    
                }
                
            }
             
            //Start the Task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> CoinData? {
        
        let decoder = JSONDecoder()
      
        do{
          let decodedData =  try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = decodedData.rate
            let currency = decodedData.asset_id_quote
            
            let coindata = CoinData(rate: lastPrice, asset_id_quote: currency)
            
            return coindata
            //print(weather.temperatureString)
         
            
        } catch{
           
            print(error)
           // delegate?.didFailWithError(error: error)
            return nil
        }
        
    
    }
    
}
