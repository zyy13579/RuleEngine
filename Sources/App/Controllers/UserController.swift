//
//  UserController.swift
//  App
//
//  Created by 赵友源 on 2019/2/12.
//

import Vapor
import Crypto

/// Controls basic CRUD operations on `Todo`s.
final class UserController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            let hashpw = try BCrypt.hash(user.password, cost: 4)
            user.password = hashpw
            return user.save(on: req)
        }
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
            }.transform(to: .ok)
    }
    
    func current(_ req: Request) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        return user
    }
}
