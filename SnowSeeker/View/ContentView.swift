//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Mihai Leonte on 30/12/2019.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var favorites = Favorites()
    @State private var isShowingSortRow = false
    @State private var isShowingFilterRow = false
    
    var sortingTypes = ["Default", "Alphabetical", "Country"]
    @State private var sortOrder = 0
        
    let data: [Resort] = Bundle.main.decode("resorts.json")
    //defined as a @State because I filter the possible types .onAppear
    @State private var countryTypes = [String]()
    @State private var countryFilter = 0
    var sizeTypes = ["All", "Small", "Medium", "Large"]
    @State private var sizeFilter = 0
    var priceTypes = ["All", "$", "$$", "$$$"]
    @State private var priceFilter = 0
    
    var resorts: [Resort] {
        var new: [Resort] = data

        if sortOrder == 1 {
            new = self.data.sorted(by: { $0.name < $1.name })
        } else if sortOrder == 2 {
            new = self.data.sorted(by: { $0.country < $1.country })
        }

        if countryFilter > 0 {
            new = new.filter({ $0.country == countryTypes[countryFilter] })
        }
        
        if sizeFilter > 0 {
            new = new.filter({ $0.size == sizeFilter })
        }
        
        if priceFilter > 0 {
            new = new.filter({ $0.price == priceFilter })
        }

        return new
    }
    
    var body: some View {
        NavigationView {
            List {
                if isShowingSortRow {
                    Picker("Sorting order", selection: $sortOrder) {
                        ForEach(0 ..< sortingTypes.count) {
                            Text("\(self.sortingTypes[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                if isShowingFilterRow {
                    Picker("Filtery by country", selection: $countryFilter) {
                        ForEach(0 ..< countryTypes.count) {
                            //Text("\(self.countryTypes[$0])")
                            Image(self.countryTypes[$0])
                                .resizable()
                                .scaledToFill()
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Filtery by size", selection: $sizeFilter) {
                        ForEach(0 ..< sizeTypes.count) {
                            Text("\(self.sizeTypes[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Picker("Filtery by size", selection: $priceFilter) {
                        ForEach(0 ..< priceTypes.count) {
                            Text("\(self.priceTypes[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                ForEach(resorts) { resort in
                    NavigationLink(destination: ResortView(resort: resort)) {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }.layoutPriority(1)
                        
                        if self.favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibility(label: Text("This is a favorite resort"))
                                .foregroundColor(Color.red)
                        }
                    }
                }
                
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading:
                    Button(action: {
                        self.isShowingFilterRow.toggle()
                    }) { Text("Filter") },
                                    trailing:
                    Button(action: {
                        self.isShowingSortRow.toggle()
                    }) { Text("Sort") })
            
            WelcomeView()
        }
        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)
        .onAppear(perform: prepData)
    }
    
    func prepData() {
        self.countryTypes = ["All"]+Array(Set(data.compactMap({ $0.country }))).sorted(by: {$0<$1})
    }
    
    // Action Sheets don't work on iPads
//    func aSheet() -> ActionSheet {
//        let def = ActionSheet.Button.default(Text("Default")) {  }
//        let alphabetical = ActionSheet.Button.default(Text("Alphabetical")) {  }
//        let country = ActionSheet.Button.default(Text("Country")) { }
//        let cancel = ActionSheet.Button.cancel() { }
//
//        let buttons: [ActionSheet.Button] = [def, alphabetical, country, cancel]
//
//        return ActionSheet(title: Text("Sort"),
//                           message: Text("Select sorting option"),
//                           buttons: buttons)
//    }

}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ContentView()
//                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
//                .previewDisplayName("iPhone 11 Pro Max")
//            
//            ContentView()
//                .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
//                .previewDisplayName("iPad Pro (11-inch)")
//        }
//    }
//}
