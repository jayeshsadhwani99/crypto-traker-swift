//
//  TopMoversItemView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct TopMoversItemView: View {
    var body: some View {
        NavigationView {
            ScrollView (.vertical, showsIndicators: false) {
                // top movers view
                
                // all coins view
            }
            .navigationTitle("Crypto Traker")
        }
    }
}

struct TopMoversItemView_Previews: PreviewProvider {
    static var previews: some View {
        TopMoversItemView()
    }
}
