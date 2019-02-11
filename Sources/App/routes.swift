import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let session = User.authSessionsMiddleware()
    let auth = router.grouped(session)
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    router.get("login") { req -> Future<View> in
        return try req.view().render("login", ["name": "Leaf"])
    }
    
    // Basic "Hello, world!" example
    auth.get("hello") { req -> String in
        let user = try req.requireAuthenticated(User.self)
        return "Hello, world, \(user.username)!"
    }
    
    auth.post("logon") { req -> EventLoopFuture<EventLoopFuture<View>> in
//        let result = try req.content.decode(LoginRequest.self).wait()
//        print(result)
//        let user = try User.query(on: req).first().wait()
//        if user == nil {
//            return try req.view().render("login", ["reason": "没有该用户"])
//        }
//        try req.authenticate(user!)
//        return try req.view().render("index", ["name": user?.username])
        return User.query(on: req).first().map{user in
            if user == nil{
                return try req.view().render("login", ["reason": "没有该用户"])
            }
            try req.authenticate(user!)
            return try req.view().render("index", ["name": user?.username])
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
