//
//  ImageDataModel.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation

struct ImageDataModel : Codable{
    let date : String?
    let hdurl : String?
    let url : String?
    let title : String?
    let explanation : String?

    enum CodingKeys : String, CodingKey{
        case date
        case hdurl
        case url
        case title
        case explanation
    }
    
    init(from decoder : Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        hdurl = try values.decodeIfPresent(String.self, forKey: .hdurl)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        explanation = try values.decodeIfPresent(String.self, forKey: .explanation)
    }
}

