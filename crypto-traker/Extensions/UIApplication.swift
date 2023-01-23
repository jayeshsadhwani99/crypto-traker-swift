//
//  UIApplication.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
