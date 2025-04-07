//
//  House.swift
//  Thrones
//
//  Created by Noah McGuire on 4/7/25.
//

import Foundation

struct House: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String
    var words: String
    enum CodingKeys: CodingKey {
        case name
        case url
        case words
    }
}
