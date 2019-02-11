import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    let session = User.authSessionsMiddleware()
    let auth = router.grouped(session)
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    auth.get("hello") { req -> String in
        let user = try req.requireAuthenticated(User.self)
        return "Hello, world, \(user.username)!"
    }
    
    auth.get("login") { req -> Future<String> in
        return User.find(1, on: req).map { user in
            guard let user = user else {
                throw Abort(.badRequest)
            }
            try req.authenticate(user)
            return "Logged in"
        }
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
