//
//  String.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
