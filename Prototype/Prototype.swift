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
    var pages: [PrototypePage]
    private var startPageId: Int
    
    var startPage: PrototypePage {
        guard let startPage = pages.filter({ $0.id == startPageId }).first else {
            return pages.first!
        }
        return startPage
    }
    
    init(name: String, source: String? = nil, id: String? = nil, url: URL? = nil, pages: [PrototypePage], startPageId: Int) {
        self.name = name
        self.source = source
        self.id = id
        self.url = url
        self.pages = pages
        self.startPageId = startPageId
    }
}
