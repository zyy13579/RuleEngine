//
//  AuthMiddleware.swift
//  App
//
//  Created by 赵友源 on 2019/3/7.
//

import Vapor

public final class AuthMiddleware:Middleware,ServiceType{
    public static func makeService(for worker: Container) throws -> AuthMiddleware {
        let authMiddleware = AuthMiddleware.init()
        return authMiddleware
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
//        let user = try request.requireAuthenticated(User.self)
//        Menu.query(on: request).all().map{ menu -> () in
//            do{
//                let session = try request.session()
//                session["user"] = "123"
//                session["menu_arr"] = "456"
//            }catch{
//            
//            }
//        }
        let response = try next.respond(to: request)
        return response
    }
    
    
}
