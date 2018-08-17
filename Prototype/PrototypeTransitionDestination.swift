//
//  PrototypeTransitionDestination.swift
//  Pods
//
//  Created by Paul Schmiedmayer on 11/11/17.
//  Copyright © 2018 Paul Schmiedmayer. All rights reserved.
//

import Foundation

enum PrototypeTransitionDestination {
    case page(id: Int)
    case back
}

extension PrototypeTransitionDestination: Equatable {
    static func == (lhs: PrototypeTransitionDestination, rhs: PrototypeTransitionDestination) -> Bool {
        switch (lhs, rhs) {
        case (.back, .back):
            return true
        case let (.page(lid), .page(rid)):
            return lid == rid
        default:
            return false
        }
    }
}

extension PrototypeTransitionDestination: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case back
    }
    
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            if let pageId = try values.decodeIfPresent(Int.self, forKey: .page) {
                self = .page(id: pageId)
                return
            }
        } catch DecodingError.typeMismatch {
            let container = try decoder.singleValueContainer()
            if try container.decode(String.self) == CodingKeys.back.rawValue {
                self = .back
                return
            }
        }
        
        throw EncodingError.invalidValue(decoder,
                                         EncodingError.Context(codingPath: decoder.codingPath,
                                                               debugDescription: "Unknown Transition"))
    }
    
    func encode(to encoder: Encoder) throws {
        switch self {
        case let .page(id):
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .page)
        case .back:
            var container = encoder.singleValueContainer()
            try container.encode(String(describing: PrototypeTransitionDestination.back))
        }
    }
}
