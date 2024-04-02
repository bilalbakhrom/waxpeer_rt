//
//  GameItem.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

public struct GameItem: Codable {
    public let itemId: String
    public let game: String
    public let name: String
    public let price: Int
    public let float: Double?
    public let paintIndex: Int?
    public let selling: Bool?
    public let stickerNames: [String]?
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.game = try container.decode(String.self, forKey: .game)
        self.name = try container.decode(String.self, forKey: .name)
        self.float = try container.decodeIfPresent(Double.self, forKey: .float)
        self.price = try container.decode(Int.self, forKey: .price)
        self.itemId = try container.decode(String.self, forKey: .itemId)
        self.paintIndex = try container.decodeIfPresent(Int.self, forKey: .paintIndex)
        self.selling = try container.decodeIfPresent(Bool.self, forKey: .selling)
        self.stickerNames = try container.decodeIfPresent([String].self, forKey: .stickerNames)
    }

    enum CodingKeys: String, CodingKey {
        case game
        case name
        case float
        case price
        case itemId = "item_id"
        case paintIndex = "paint_index"
        case selling
        case stickerNames = "sticker_names"
    }
}
