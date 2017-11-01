//
//  Prototype.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2017 Paul Schmiedmayer. All rights reserved.
//

import Foundation

class Prototype: Codable {
    let id: String?
    let name: String
    let source: String?
    let url: URL?
    let pages: [PrototypePage]
    private let startPageId: Int
    var startPage: PrototypePage!
    
    
    private enum CodingKeys: String, CodingKey {
        case name
        case source
        case id
        case url
        case pages
        case startPageId
    }
    
    init?(name: String, source: String? = nil, id: String? = nil, url: URL? = nil, pages: [PrototypePage], startPageId: Int) {
        self.name = name
        self.source = source
        self.id = id
        self.url = url
        self.pages = pages
        self.startPageId = startPageId
        
        if !self.loadStartPage() {
            return nil
        }
    }
    
    private func loadStartPage() -> Bool {
        if let startPage = pages.filter({ $0.id == startPageId }).first {
            self.startPage = startPage
            return true
        } else if let startPage = pages.first {
            self.startPage = startPage
            return true
        }
        return false
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try values.decode(String.self, forKey: .name)
        self.source = try values.decodeIfPresent(String.self, forKey:  .source)
        self.id = try values.decodeIfPresent(String.self, forKey:  .id)
        self.url = try values.decodeIfPresent(URL.self, forKey:  .url)
        self.pages = try values.decode([PrototypePage].self, forKey: .pages)
        self.startPageId = try values.decode(Int.self, forKey: .startPageId)
        
        if !self.loadStartPage() {
            throw NSError()
        }
    }
}
