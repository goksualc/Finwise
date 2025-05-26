//
//  FundTypeETFListView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/26/25.
//

import SwiftUI

struct FundTypeETFListView: View, Identifiable {
    let fundType: String
    var id: String { fundType }
    var yahooURL: URL {
        let base = "https://finance.yahoo.com/research-hub/screener/etf/?start=0&count=25"
        let query = fundType.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "\(base)&query=\(query)")!
    }
    var body: some View {
        NavigationStack {
            WebView(url: yahooURL)
                .navigationTitle("\(fundType) ETF's")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
