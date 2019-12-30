//
//  SkiDetailsView.swift
//  SnowSeeker
//
//  Created by Mihai Leonte on 30/12/2019.
//  Copyright © 2019 Mihai Leonte. All rights reserved.
//

import SwiftUI

struct SkiDetailsView: View {
    let resort: Resort
    
    var body: some View {
        Group {
            Text("Elevation: \(resort.elevation)m")
            Spacer().frame(height: 0)
            Text("Snow: \(resort.snowDepth)cm")
        }
    }
}

//struct SkiDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SkiDetailsView()
//    }
//}
