//
//  ExchangeRate.swift
//  ByteCoin
//
//  Created by Carlos Garcia-Muskat on 04/05/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct ExchangeRateModel: Codable {
    let asset_id_base: String
    let assest_id_quote: String
    let rate: Double
    
    var rateString: String {
           return String(format: "%.1f", rate)
       }
}
