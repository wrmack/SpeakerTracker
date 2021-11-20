//
//  ClockOverlayView.swift
//  Speaker-tracker-multi
//
//  Created by Warwick McNaughton on 19/11/21.
//

import SwiftUI

struct ClockOverlayView: View {
    
    @Binding var timerString: String
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center) {
                Spacer()
                HStack {
                    Spacer()
                    Text(timerString)
                        .font(.custom("Arial Rounded MT Bold", size: geo.size.width > 1000 ? 400 : 300))
                        .foregroundColor(.red)
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

//struct ClockOverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClockOverlayView()
//    }
//}
