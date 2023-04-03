//
//  PlaceSearchService.swift
//  TATapp
//
//  Created by Waleerat Gottlieb on 2023-04-03.
//

import Foundation
import Combine
import SwiftUI

enum ParmeterOfRequest {
    case PlaceSearch
    case EventList
    case RouteList
}

class TATApiService {
    
    @Published var placeSearchItems: PlaceSearchModel? = nil
    @Published var attractionDetail: AttractionDetailModel? = nil
    @Published var accommodationDetail: AccommodationDetailModel?  = nil
    @Published var restaurantDetail: RestaurantDetailModel?  = nil
    @Published var shopDetail: ShopDetailModel? = nil
    @Published var placeOtherDetail: PlaceOtherDetailModel?  = nil
    @Published var eventList: EventListModel?  = nil
    @Published var eventDetail: EventDetailModel?  = nil
    @Published var routeList: RouteListModel?  = nil
    @Published var routeDetail: RouteDetailModel?  = nil
    
    @Published var language: String = "th"
    
    //GetPlaceSearch
    @Published var categorycodes:String = "RESTAURANT"
    @Published var keyword:String?
    @Published var location:String?
    @Published var provinceName:String?
    @Published var radius:Int?
    @Published var destination:String?
    //Event Search
    @Published var geolocation:String?
    @Published var sortby:String?  // distance or distance[default]
    // Route Search
    @Published var day: Int?
    
    @Published var pagenumber: Int?
    @Published var numberOfResult: Int?
    @Published var updateDate:String?
    
    
    @Published var parameters: [String:String] = [:]
    
    private let fileManager = LocalFileManager.instance
    var subscription: AnyCancellable?
    
    init(){
        getPlaceSearch()
    }
     
    func getPlaceSearch() {
        numberOfResult = 10
        pagenumber = 1
        parameters = getQueryParameter(parmeterOfRequest: .PlaceSearch)
        
        let apiRequest = ApiRequest.GetPlaceSearch.path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: parameters)
            .decode(type: PlaceSearchModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.placeSearchItems = result
                self?.subscription?.cancel()
            })
        
    }
    
    /**
     Get Attraction Details. Additional information about specified location such as open-close time, telephone number, email, etc.
     
    - **HTTP Request** https://tatapi.tourismthailand.org/tatapi/v5/attraction/{place_id}
   
    - **HTTP Header**
         - *Content-Type* : application/json, text/json
         - *Authorization* : Bearer {Your TAT API key}
         - *Accept-Language* : Display language support: "th" or "en"
     
     - Throws: None
     - Parameters:
        - place_id: String  ID of Place which are returned from TAT services for example 'PlaceSearch'
     */
    func getAttractionDetail(placeId: String){
        // placeId = "P03000001"
        let apiRequest = ApiRequest.GetAttractionDetail(placeId: placeId).path 
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: AttractionDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.attractionDetail = result
                self?.subscription?.cancel()
            })
        
    }

    /**
     Get Attraction Details. Additional information about specified location such as open-close time, telephone number, email, etc.
     
    - **HTTP Request** https://tatapi.tourismthailand.org/tatapi/v5/attraction/{place_id}
   
    - **HTTP Header**
         - *Content-Type* : application/json, text/json
         - *Authorization* : Bearer {Your TAT API key}
         - *Accept-Language* : Display language support: "th" or "en"
     
     - Return : AccommodationDetailModel
     - Parameters:
        - place_id: String  ID of Place which are returned from TAT services for example 'PlaceSearch'
     */
    func getAccommodationDetail(placeId: String){
         //placeId = "P02000001"
        let apiRequest = ApiRequest.GetAccommodationDetail(placeId: placeId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: AccommodationDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.accommodationDetail = result
                self?.subscription?.cancel()
            })
    }
    
    func getRestaurantDetail(placeId: String){
        let apiRequest = ApiRequest.GetRestaurantDetail(placeId: placeId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: RestaurantDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.restaurantDetail = result
                self?.subscription?.cancel()
            })
        
    }
    
    func getShopDetail(placeId: String){
        let apiRequest = ApiRequest.GetShopDetail(placeId: placeId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: ShopDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.shopDetail = result
                self?.subscription?.cancel()
            })
    }
    
    func getPlaceOtherDetail(placeId: String){
        let apiRequest = ApiRequest.GetPlaceOtherDetail(placeId: placeId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: PlaceOtherDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.placeOtherDetail = result
                self?.subscription?.cancel()
            })
    }
    
    func getEventList(){
        numberOfResult = 10
        pagenumber = 1
        parameters = getQueryParameter(parmeterOfRequest: .EventList)
        
        let apiRequest = ApiRequest.GetEventList.path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: parameters)
            .decode(type: EventListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.eventList = result
                self?.subscription?.cancel()
            })
    }
    
    func getEventDetail(eventId: String){
        let apiRequest = ApiRequest.GetEventDetail(eventId: eventId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: EventDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.eventDetail = result
                self?.subscription?.cancel()
            })
    }
   
    func getRecommendedRouteList(){
        numberOfResult = 10
        pagenumber = 1
        parameters = getQueryParameter(parmeterOfRequest: .RouteList)
        
        let apiRequest = ApiRequest.GetRecommendedRouteList.path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: parameters)
            .decode(type: RouteListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.routeList = result
                self?.subscription?.cancel()
            })
    }
    func getRecommendedRouteDetail(routeId: String){
        let apiRequest = ApiRequest.GetRecommendedRouteDetail(routeId: routeId).path
        subscription = NetworkingManager.download(apiRequest: apiRequest, language: language, parameters: nil)
            .decode(type: RouteDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (result) in
                self?.routeDetail = result
                self?.subscription?.cancel()
            })
    }
    
    func getSHASearch(){}
    func getSHADetail(placeId: String){}
    
    func gostChatbotPrediction(){}
    func gostChatbotSendMessage(){}
    func getNewsList(){}
    func getNewsDetail(newsId: String){}
    
    // MARK: - Helper functions
    func getAddress(location: Location) -> String {
        var address = ""
        if (location.address != "") { address +=  "\(location.address) " }
        if (location.subDistrict != "") { address +=  "\(location.subDistrict) " }
        if (location.district != "") { address +=  "\(location.district) " }
        if (location.province != "") { address +=  "\(location.province) " }
        if (location.postcode != "") { address +=  "\(location.postcode) " }
        
        return address
    }
    
    func getShaTypeDescription(sha: SHA) -> String {
        return "\(sha.shaTypeDescription)"
        
    }
    
    func getQueryParameter(parmeterOfRequest : ParmeterOfRequest) -> [String:String]{
        var query: [String:String] = [:]
        
        switch (parmeterOfRequest){
        case .PlaceSearch:
            query["categorycodes"] = categorycodes
            if let keyword = keyword {  query["keyword"] = keyword }
            if let location = location { query["location"] = location }
            if let provinceName = provinceName { query["provinceName"] = provinceName }
            if let radius = radius { query["radius"] = String(radius) }
            if let destination = destination { query["destination"] = destination }
        case .EventList:
            if let geolocation = geolocation {  query["geolocation"] = geolocation }
            if let sortby = sortby { query["sortby"] = sortby }
        case .RouteList:
            if let day = day { query["day"] = String(day) }
        }
        
        if let numberOfResult = numberOfResult {
            query["numberOfResult"] = String(numberOfResult)
        }
        if let pagenumber = pagenumber {
            query["pagenumber"] = String(pagenumber)
        }
        if let updateDate = updateDate {
            query["updateDate"] = updateDate
        }
        return query
        
    }
    
}


/**
This service allows you to search place information in TAT POI, You can query specified area by sending parameters, category or province name.

- **HTTP Request** https://tatapi.tourismthailand.org/tatapi/v5/places/search

- **HTTP Header**
    - *Content-Type* : application/json, text/json
    - *Authorization* : Bearer {Your TAT API key}
    - *Accept-Language* : Display language support: "th" or "en"
- **Example parameters**
    {
    "keyword":"อาหาร"
    "location":"13.6904831,100.5226014"
    "categorycodes":"RESTAURANT"
    "provinceName":"Bangkok"
    "radius":20
    "numberOfResult":10
    "pagenumber":1
    "destination":"Bangkok"
    "filterByUpdateDate":"2019/09/01-2021/12/31"
    }

- **Example Request URL**
 https://tatapi.tourismthailand.org/tatapi/v5/places/search?keyword=อาหาร&location=13.6904831,100.5226014&categorycodes=RESTAURANT&provinceName=Bangkok&radius=20&numberOfResult=10&pagenumber=1&destination=Bangkok&filterByUpdateDate=2019/09/01-2021/12/31
 
- Throws: None
- Parameters:
   - categorycodes: String  (ex : "RESTAURANT")
        • ALL = All Category,
        • OTHER = Other Place Type,
        • SHOP = Shopping Type,
        • RESTAURANT = Restaurant Type,
        • ACCOMMODATION = Hotel Type,
        • ATTRACTION = Attraction Type
           TAT ’s Place category such as "SHOP|ACCOMMODATION". All categories are separated using the pipe (|) character.
   - keyword :String?  A term to be matched with TAT place name, mapcode or latitude,longitude.
   - location: String? example: location=13.7222793,100.528923
   - provinceName: String?  Refer to province name in Thailand.
   - radius: Int? Decimal number    Optional    Defines the distance (in meter) within latitude (Lat) and longitude (Lon) parameter. Default value is 1,000 meters and Maximum value is 200,000 meters.
   - numberOfResult: Int? Number of record to return per/page. Default value is "50" and Maximum value is "100".
   - pagenumber: Int? Number of Page. Default is 1.
   - destination: String? Refer to destination name in TAT.
   - updateDate: String? Filter by update date of value the POI
- Returns: PlaceSearchModel

*/
