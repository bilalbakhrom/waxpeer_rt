//
//  GameItem.swift
//
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import Foundation

public struct GameItem: Codable, Identifiable, Hashable {
    public let id: String
    public let game: String
    public let name: String
    public let price: Int
    public let float: Double?
    public let paintIndex: Int?
    public let selling: Bool?
    public let stickerNames: [String]?
    
    public var iconName: String {
        if game.contains("csgo") {
            return "icon.csgo"
        } else if game.contains("tf") {
            return "icon.tf"
        } else if game.contains("rust") {
            return "icon.rust"
        } else {
            return "icon.dota"
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.game = try container.decode(String.self, forKey: .game)
        self.name = try container.decode(String.self, forKey: .name)
        self.float = try container.decodeIfPresent(Double.self, forKey: .float)
        self.price = try container.decode(Int.self, forKey: .price)
        self.id = try container.decode(String.self, forKey: .id)
        self.paintIndex = try container.decodeIfPresent(Int.self, forKey: .paintIndex)
        self.selling = try container.decodeIfPresent(Bool.self, forKey: .selling)
        self.stickerNames = try container.decodeIfPresent([String].self, forKey: .stickerNames)
    }

    enum CodingKeys: String, CodingKey {
        case id = "item_id"
        case game
        case name
        case float
        case price
        case paintIndex = "paint_index"
        case selling
        case stickerNames = "sticker_names"
    }
}
