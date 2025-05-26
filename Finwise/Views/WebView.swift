//
//  WebView.swift
//  Finwise
//
//  Created by Göksu Alçınkaya on 5/27/25.
//

import SwiftUI
import WebKit

// MARK: - WebView for Yahoo Finance ETF Screener
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
