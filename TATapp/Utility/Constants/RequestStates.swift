//
//  UIStates.swift
//  TATapp
//
//  Created by Waleerat Gottlieb on 2023-04-04.
//

import Foundation

enum ScreenState {
    case Landing
    case Home
}

/// For UI State for `Start, Rating Selection, Confirmation, result` screen.
enum RequestStates {
    case None
    case GetPlaceSearch
    case GetPlaceNearBy
    case GetAttractionDetail
    case GetAccommodationDetail
    case GetRestaurantDetail
    case GetShopDetail
    case GetPlaceOtherDetail
    case GetEventList
    case GetEventDetail
    case GetRecommendedRouteList
    case GetRecommendedRouteDetail
    case GetSHASearch
    case GetSHADetail
    /*
    case PostChatbotPrediction
    case PostChatbotSendMessage
    case GetNewsList
    case GetNewsDetail*/
}
