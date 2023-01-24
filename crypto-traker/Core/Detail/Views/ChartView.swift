//
//  ChartView.swift
//  crypto-traker
//
//  Created by Jayesh Sadhwani on 24/01/23.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(
                    chartYAxis
                    .padding(.horizontal, 4),
                         alignment: .leading
                )
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
        
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    /// calculate the x position
                    /// get the width for each point - (length of chart / number of points)
                    /// then just multiply by the (index of point + 1)
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    // to get the y position,
                    // we first have to get
                    // a range between min and max
                    let yAxis = maxY - minY
                    
                    /// calculate the y position
                    /// given the value, we can find the points
                    /// it will be above minY
                    /// then we can divide it by yAxis
                    /// to get the percentage.
                    /// The point will be that percentage of the total height.
                    ///
                    /// since the coordinate system of iPhone is reverse,
                    /// we just substract the percentage from 1 to get the opposite
                    /// value.
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0.3), radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 30)
        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let middlePrice = (maxY - minY / 2).formattedWithAbbreviations()
            Text(middlePrice)
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
