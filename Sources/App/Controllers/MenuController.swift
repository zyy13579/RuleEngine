//
//  MenuController.swift
//  App
//
//  Created by 赵友源 on 2019/2/14.
//

import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class MenuController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[Menu]> {
        return Menu.query(on: req).all()
    }
    
    /// Saves a decoded `Todo` to the database.
    func create(_ req: Request) throws -> Future<Menu> {
        return try req.content.decode(Menu.self).flatMap { menu in
            return menu.save(on: req)
        }
    }
    
    /// Deletes a parameterized `Todo`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Menu.self).flatMap { menu in
            return menu.delete(on: req)
            }.transform(to: .ok)
    }
}
