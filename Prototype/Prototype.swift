//
//  Prototype.swift
//  Prototype
//
//  Created by Paul Schmiedmayer on 7/3/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
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
        guard let startPage = pages.first(where: { $0.id == startPageId }) else {
            guard let firstPage = pages.first else {
                fatalError("The prototype to be displayed has zero pages")
            }
            return firstPage
        }
        return startPage
    }
    
    init(name: String,
         source: String? = nil,
         id: String? = nil,
         url: URL? = nil,
         pages: [PrototypePage],
         startPageId: Int) {
        self.name = name
        self.source = source
        self.id = id
        self.url = url
        self.pages = pages
        self.startPageId = startPageId
    }
}
