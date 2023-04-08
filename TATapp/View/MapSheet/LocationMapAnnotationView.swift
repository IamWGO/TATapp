//
//  LocationMapAnnotationView.swift
//  TATapp
//
//  Created by Waleerat Gottlieb on 2023-04-08.
//

import SwiftUI

struct LocationMapAnnotationView: View {
    @State var placeName: String
    let accentColor = Color.theme.primary
    
    var body: some View {
            VStack(spacing: 0) {
                Image(systemName: "map.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(accentColor)
                    .clipShape(Circle())
                
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(accentColor)
                    .frame(width: 10, height: 10)
                    .rotationEffect(Angle(degrees: 180))
                    .offset(y: -3)
                    .padding(.bottom, 40)
            }
    }
}

struct LocationMapAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            LocationMapAnnotationView()
        }
    }
}
