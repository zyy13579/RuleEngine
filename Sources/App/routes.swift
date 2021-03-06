import Vapor
import Crypto
import Random
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let session = User.authSessionsMiddleware()
    let auth = router.grouped(session)
    // Basic "It works" example
    auth.get { req -> Response in
        return req.redirect(to: "/index")
    }
    
    auth.get("index") { req -> Future<View> in
        let islogon = try req.isAuthenticated(User.self)
        if islogon == true {
            return try req.view().render("index")
        }
        else{
            return try req.view().render("login")
        }
    }
    
    router.get("login") { req -> Future<View> in
        return try req.view().render("login")
    }
    
    // Basic "Hello, world!" example
    auth.get("hello") { req -> String in
        let user = try req.requireAuthenticated(User.self)
        return "Hello, world, \(user.username)!"
    }
    
    auth.post("logon") { req -> EventLoopFuture<EventLoopFuture<Response>> in
        return try req.content.decode(LoginRequest.self).map{loginRequest -> EventLoopFuture<Response> in
            let lr = loginRequest
            return User.query(on: req).filter(\.username == lr.username).first().map{ user in
                if user == nil{
//                    return try req.view().render("login", ["reason": "没有该用户"])
                    return req.redirect(to: "/login?reason=没有该用户")
                }
                let u = user!
                let result = try BCrypt.verify(lr.password, created: u.password)
                if result == false{
//                    return try req.view().render("login", ["reason": "用户名密码不正确"])
                    return req.redirect(to: "/login?reason=用户名密码不正确")
                }
                try req.authenticate(u)
//                return try req.view().render("admin", ["user": u])
                return req.redirect(to: "/index")
            }
        }
    }
    
    auth.get("logout") { req -> Response in
        try req.destroySession()
        return req.redirect(to: "/login")
    }
    

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    let userController = UserController()
    router.get("users/list", use: userController.list)
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)
    router.delete("users", User.parameter, use: userController.delete)
    
    let menuController = MenuController()
    router.get("menus", use: menuController.index)
    router.post("menus", use: menuController.create)
    router.delete("menus", Menu.parameter, use: menuController.delete)
    
    let adminController = AdminController()
    auth.get("admin/currentUser",use: adminController.currentUser)
    auth.get("admin/currentMenu",use: adminController.currentMenu)
}
