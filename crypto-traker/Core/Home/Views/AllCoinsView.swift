//
//  AllCoinsView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct AllCoinsView: View {
    var body: some View {
        VStack (alignment: .leading) {
            Text("All coins")
                .font(.headline)
                .padding()
            
            HStack {
                Text("Coin")
                
                Spacer()
                
                Text("Prices")
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            .font(.caption)
            
            ScrollView {
                VStack {
                    ForEach(0 ..< 50, id: \.self) { _ in
                        CoinRowView()
                    }
                }
            }
        }
    }
}

struct AllCoinsView_Previews: PreviewProvider {
    static var previews: some View {
        AllCoinsView()
    }
}
