//
//  NewGameResponse.swift
//  iOSCarePlus
//
//  Created by 남수김 on 2020/12/16.
//

import Foundation

struct NewGameContent: Decodable {
    let formalName: String
    let heroBannerURL: String
    let identifier: Int
    let screenshots: [NewGameScreenshot]
    
    enum CodingKeys: String, CodingKey {
        case formalName = "formal_name"
        case heroBannerURL = "hero_banner_url"
        case identifier = "id"
        case screenshots
    }
}

struct NewGameScreenshot: Decodable {
    let images: [NewGameImages]
}

struct NewGameImages: Decodable {
    let url: String
}

struct NewGameResponse: Decodable {
    var contents: [NewGameContent]
    let length: Int
    let offset: Int
    let total: Int
}
