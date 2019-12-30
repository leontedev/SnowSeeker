//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Mihai Leonte on 30/12/2019.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct ResortDetailsView: View {
    let resort: Resort
    var size: String {
        switch resort.size {
            case 1:
                return "Small"
            case 2:
                return "Average"
            default:
                return "Large"
        }
    }
    var price: String {
        String(repeating: "$", count: resort.price)
    }
    
    
    var body: some View {
        Group {
            Text("Size: \(size)")
            Spacer().frame(height: 0)
            Text("Price: \(price)")
        }
    }
}

//struct ResortDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResortDetailsView()
//    }
//}
