//
//  StockView.swift
//  WatchStock
//
//  Created by Bona Deny S on 10/12/20.
//  Copyright © 2020 Bona Deny S. All rights reserved.
//

import SwiftUI

struct StockView: View {
    @ObservedObject var viewModel: StockViewModel
        
    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(viewModel.loading)) {
                VStack {
                    SearchbarView(viewModel: self.viewModel)
                    List {
                        HStack {
                            Button(action: {
                                self.viewModel.byDate()
                            }){
                                Text("Date")
                                }.frame(width: 100, alignment: .leading).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.viewModel.byOpen()
                            }){
                                Text("Open")
                            }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.viewModel.byHigh()
                            }){
                                Text("High")
                                }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                self.viewModel.byLow()
                            }){
                                Text("Low")
                                }.frame(width: 80, alignment: .trailing).buttonStyle(BorderlessButtonStyle())
                        }
                        ForEach(self.viewModel.stocks) { stock in
                            HStack {
                                Text(stock.date).frame(width: 100, height: 50, alignment: .trailing)
                                Text(stock.open).frame(width: 80, alignment: .trailing)
                                Text(stock.high).frame(width: 80, alignment: .trailing)
                                Text(stock.low).frame(width: 80, alignment: .trailing)
                            }
                        }
                    }
                }.navigationBarTitle("\(self.viewModel.title) : \(self.viewModel.symbol)")
            }.onAppear() {
                self.viewModel.fetch(symbol: self.viewModel.symbol)
            }
        }
    }
}

struct SearchbarView: View {
    @ObservedObject var viewModel: StockViewModel
    
    @State private var showCancelButton: Bool = false
    @State private var searchText = ""
    
    var body: some View {
        HStack {
            HStack {
                Button(action: {
                    self.viewModel.fetch(symbol: self.searchText)
                }) {
                     Image(systemName: "magnifyingglass")
                }

                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = true
                }, onCommit: {
                    self.viewModel.fetch(symbol: self.searchText)
                    self.viewModel.symbol = self.searchText
                }).foregroundColor(.primary)

                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }.padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)

                if showCancelButton  {
                    Button("Cancel") {
                            UIApplication.shared.endEditing(true)
                            self.searchText = ""
                            self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }.padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView(viewModel: StockViewModel())
    }
}
