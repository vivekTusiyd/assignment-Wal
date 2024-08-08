//
//  ImageDataModel.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation

struct ImageDataModel : Codable{
    let date : String?
    let start_date : String?
    let end_date : String?
    let count : Int?
    let thumbs : Bool?
    let api_key : String?
    let title : String?
    let description : String?

    enum CodingKeys : String, CodingKey{
        case date
        case start_date
        case end_date
        case count
        case thumbs
        case api_key
        case title
        case description
    }
    
    init(from decoder : Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        start_date = try values.decodeIfPresent(String.self, forKey: .start_date)
        end_date = try values.decodeIfPresent(String.self, forKey: .end_date)
        count = try values.decodeIfPresent(Int.self, forKey: .count)
        thumbs = try values.decodeIfPresent(Bool.self, forKey: .thumbs)
        api_key = try values.decodeIfPresent(String.self, forKey: .api_key)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}

