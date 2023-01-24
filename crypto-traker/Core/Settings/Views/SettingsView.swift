//
//  SettingsView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://google.com")!
    let githubLink = URL(string: "https://github.com/jayeshsadhwani99/crypto-tracker-swift")!
    let coingekoURL = URL(string: "https://coingecko.com")!
    let personalURL = URL(string: "https://github.com/jayeshsadhwani99")!
    
    var body: some View {
        NavigationView {
            List {
                cryptoTrackerView
                coingekoSection
                developerSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            }
        }
        .background(Color.theme.background)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}

extension SettingsView {
    private var cryptoTrackerView: some View {
        Section {
            VStack (alignment: .leading) {
                    Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app uses the MVVM Architecture, Combine and Core Data. The code is open sourced on github")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("View Source", destination: githubLink)
        }
        header: {
            Text("Crypto Tracker")
        }
    }
    
    private var coingekoSection: some View {
        Section {
            VStack (alignment: .leading) {
                    Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The data that is used in this app comes from a public API called coin gecko. Prices might be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingekoURL)
        }
        header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack (alignment: .leading) {
                    Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was developed by Jayesh Sadhwani and uses SwiftUI. It benefits from multithreading, pub/sub model and data persistence. Check out my other work on github.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Github", destination: personalURL)
        }
        header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
        header: {
            Text("Application")
        }
    }
}
