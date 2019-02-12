//
//  Menu.swift
//  App
//
//  Created by 赵友源 on 2019/2/12.
//

import FluentPostgreSQL
import Vapor

/// A single entry of a Todo list.
final class Menu: PostgreSQLModel {
    /// The unique identifier for this `Todo`.
    var id: Int?
    
    /// A title describing what this `Todo` entails.
    var name: String
    
    var description: String?
    
    var icon: String?
    
    var url: String?
    
    var sort: Int
    
    var parentId: Int?
    
    var canClick: Bool
    
    
    /// Creates a new `Todo`.
    init(id: Int? = nil, name: String, description: String? ,icon: String? ,url: String?,sort: Int,parentId: Int?,canClick: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.url = url
        self.sort = sort
        self.parentId = parentId
        self.canClick = canClick
    }
}

/// Allows `Todo` to be used as a dynamic migration.
extension Menu: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension Menu: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension Menu: Parameter { }
