//
//  AdminController.swift
//  App
//
//  Created by 赵友源 on 2019/2/13.
//


import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class AdminController {
    /// Returns a list of all `Todo`s.
    func index(_ req: Request) throws -> Future<[String:Any]> {
        let user = try req.requireAuthenticated(User.self)
        return Menu.query(on: req).all().map{ menu -> [String:Any] in
            return ["user":user,"menu_arr":menu]
        }
    }
    
    func currentUser(_ req: Request) throws -> User {
        let user = try req.requireAuthenticated(User.self)
        return user
    }
    
    func currentMenu(_ req: Request) throws -> Future<[Menu]> {
        return Menu.query(on: req).all()
    }
    
}
