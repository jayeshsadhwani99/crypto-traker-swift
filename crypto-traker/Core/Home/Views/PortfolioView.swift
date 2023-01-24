//
//  PortfolioView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 23/01/23.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var selectedCoin: Coin? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    
                    SearchBarView(searchText: $viewModel.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSelection
                    }
                    
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            }
            .onChange(of: viewModel.searchText) { value in
                if value == "" {
                    removeSelectedCoin()
                }
            }
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portfolioCoins : viewModel.coins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?  Color.theme.green : Color.clear, lineWidth: 1)
                        )
                }
            }
            .padding()
            .frame(height: 120)
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        
        if let portfolioCoin = viewModel.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private var portfolioInputSelection: some View {
        VStack (spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                
                Text(selectedCoin?.currentPrice.toCurrency() ?? "")
            }
            
            Divider()
            
            HStack {
                Text("Amount holding:")
                
                Spacer()
                
                TextField("Ex 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current Value")
                
                Spacer()
                
                Text(getCurrentValue().toCurrency())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButtons: some View {
        HStack (spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
                    .font(.headline)
            }
            .opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)
        }
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
              
        else { return }
        
        // save to portfolio
        viewModel.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
    }
}
