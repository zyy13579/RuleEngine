//
//  User.swift
//  App
//
//  Created by 赵友源 on 2019/2/11.
//

import FluentPostgreSQL
import Authentication
import Vapor

/// A single entry of a Todo list.
final class User: PostgreSQLModel {
    /// The unique identifier for this `Todo`.
    var id: Int?
    
    /// A title describing what this `Todo` entails.
    var username: String
    
    var password: String
    
    /// Creates a new `Todo`.
    init(id: Int? = nil, username: String, password: String ) {
        self.id = id
        self.username = username
        self.password = password
    }
    
}

/// Allows `Todo` to be used as a dynamic migration.
extension User: Migration { }

/// Allows `Todo` to be encoded to and decoded from HTTP messages.
extension User: Content { }

/// Allows `Todo` to be used as a dynamic parameter in route definitions.
extension User: Parameter { }

extension User: SessionAuthenticatable { }
