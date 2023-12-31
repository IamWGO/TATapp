//
//  PlaceDescriptionView.swift
//  TATapp
//
//  Created by Waleerat Gottlieb on 2023-04-14.
//

import SwiftUI
import MapKit

struct PlaceDescriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var mainVM: MainViewModel
    @EnvironmentObject var vm: PlaceViewModel
    
    @State var placeItem: PlaceItemModel
    @State var offsetHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .top) {
            
            ScrollView(showsIndicators: false){
                bodyContainer
            } 
        }
        .sheet(isPresented: $vm.isShowMapSheet, content: {
            MapSheetView(mainVM: mainVM, placeItem: placeItem)
        })
        .modifier(HiddenNavigationBarModifier())
    }
}

extension PlaceDescriptionView {
    
    private var bodyContainer: some View {
        // Since Were Pinning Header View....
        return LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [.sectionHeaders], content: {
            
            // Parallax Header....
            GeometryReader{ reader -> AnyView in
                
                let offset = reader.frame(in: .global).minY
                
                if -offset >= 0{
                    DispatchQueue.main.async {
                        self.vm.offset = -offset
                    }
                }
                
                return AnyView(
                    
                    TabView {
                        ForEach(placeItem.getImages(), id: \.self) { imageUrl in
                            PlaceImageView(imageName: imageUrl)
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: offsetHeight + (offset > 0 ? offset : 0))
                                .clipped()
                        }
                    }
                    .frame(height: offsetHeight)
                    .offset(y: (offset > 0 ? -offset : 0))
                    .tabViewStyle(PageTabViewStyle())

                    )
                    
            }
            .frame(height: offsetHeight)
            
            // Cards......
            Section(header: headerSection) {
                // Content Detail.....
                placeInformation
            }
        })
    }
    
    private var placeInformation: some View {
        VStack(alignment: .leading, spacing: 15) {
            
            if let phoneNumber = placeItem.getContactNumbers() {
                VStack(alignment: .trailing, spacing: 8) {
                    Image(systemName: "phone")
                        .font(.caption)
                    Text(phoneNumber)
                        .modifier(TextModifier(fontStyle: .body))
                }
                .padding(.bottom)
            }
            
            Text(placeItem.placeInformation.detail)
                .modifier(TextModifier(fontStyle: .body))
            
            mapLayerSection
            
            if let openingHours = placeItem.openingHours {
                openingHoursSection(openingHours: openingHours)
            }
        }.padding()
    }
    
    private var mapLayerSection: some View {
        Map(coordinateRegion: .constant(placeItem.mapRegion),
            annotationItems: [placeItem]) { placeItem in
            MapAnnotation(coordinate: placeItem.getCoordinate()) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
            .allowsHitTesting(false)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
    }
    
    private var headerSection: some View {
     
        return VStack(alignment: .leading, spacing: 0){
            ZStack{
                shortDetailSection
            }
            // Default Frame = 60...
            // Top Fram = 40
            // So Total = 100
            .frame(height: 60)
        }
        .frame(height: vm.offset > offsetHeight ? 200 : 140) //header with top image
        .background(scheme == .dark ? Color.black : Color.white)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.primary.opacity(vm.offset > offsetHeight ? 0.2 : 0))
                .frame(height: 1)
                .shadow(
                    color: Color.theme.primary.opacity(0.25),
                    radius: 10, x: 0, y: 0)
        }
       
    }
    
    private var shortDetailSection: some View {
    
       return VStack(alignment: .leading, spacing: 0){
            ZStack{
                
                VStack(alignment: .leading, spacing: 10, content: {
                    headerDescription
                })
                .opacity(vm.offset > 200 ? 1 - Double((vm.offset - 200) / 50) : 1)
                 
            }
            // Default Frame = 60...
            // Top Fram = 40
            // So Total = 100
            .frame(height: 60)
           
           if vm.offset > offsetHeight{
               headerDescription
                   .padding(.horizontal)
                   
           }
        }
        .padding(.horizontal)
        .background(scheme == .dark ? Color.black : Color.white)
        
        
    }
    
    private var headerDescription: some View {
    
       return VStack(alignment: .leading, spacing: 6, content: {
            
           Text(placeItem.placeName)
               .modifier(TextModifier(fontStyle: .title3, fontWeight: .semibold))
          
            Spacer()
            
            HStack(spacing: 8){
                
                Image(systemName: "mappin.and.ellipse")
                    .font(.caption)
                Text(placeItem.getDistrictAndProvince())
                    .modifier(TextModifier(fontStyle: .caption))
                
                Spacer()
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            HStack{
                Spacer()
                VStackButtonActionView(systemName: .constant(vm.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"),
                                       textButton: .constant("123K"),
                                       foregroundColor: .constant(vm.isLiked ? Color.theme.active : Color.theme.inactive),
                                       isDisable: $vm.isLiked) {
                    vm.saveLiked()
                }
            
                Spacer()
                VStackButtonActionView(systemName: .constant(vm.isBookMark ? "bookmark.fill" : "bookmark"),
                                       textButton: .constant("Saved"),
                                       foregroundColor: .constant(vm.isBookMark ? Color.theme.active : Color.theme.inactive),
                                       isDisable: $vm.isBookMark) {
                    vm.saveBookmark()
                }
                
                Spacer()
                VStackButtonActionView(systemName: .constant("map"),
                                       textButton: .constant("Map"),
                                       foregroundColor: .constant(vm.isShowMapSheet ? Color.theme.active : Color.theme.inactive),
                                       isDisable: .constant(!placeItem.isHasLocation())) {
                    
                    vm.toggleMapIcon()
                }
               
                Spacer()
            }
            
        })
        .padding(.top, vm.offset > offsetHeight ? 0 : 20)
        .padding(.bottom)
    }
    
    private var addressSection: some View {
        Text(placeItem.placeName)
    }
    
    private func openingHoursSection(openingHours: BusinessHours) -> some View {
        return ZStack(alignment: .top){
           
            VStack {
                VStack(alignment: .trailing, spacing: 8) {
                    
                    VStack {
                        if let openNow = openingHours.openNow {
                            if openNow {
                                Text("Open Now")
                                    .modifier(TextModifier(fontStyle: .body))
                            } else {
                                Text("Close Now")
                                    .modifier(TextModifier(fontStyle: .body, foregroundColor: Color.red))
                            }
                        }
                        
                    }.padding(.bottom)
                    if let weekdayText = openingHours.weekdayText {
                        if let openPeriod = weekdayText.day1 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day2 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day3 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day4 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day5 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day6 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                        if let openPeriod = weekdayText.day7 {
                            getOpenHours(day: openPeriod.day, time: openPeriod.time)
                        }
                    }
                }
            }
        }
    }
    
    private func getOpenHours(day: String, time: String)  -> some View {
       return HStack {
            Text(day)
               .modifier(TextModifier(fontStyle: .body))
            Spacer()
            Text(time)
                .modifier(TextModifier(fontStyle: .body))
        }
       .frame(width: isIpad ? offsetHeight : 300)
    }
}
