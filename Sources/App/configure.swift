import FluentPostgreSQL
import Authentication
import Leaf
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Droplet
    
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    try services.register(AuthenticationProvider())
    try services.register(LeafProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)

    // Configure a postgres database
    // let pgAddress = Environment.get("PGADDRESS")!
    // let pgAddress = "postgresql://vapor:123456@localhost:5432/vapor"
    // let postgresconfig = PostgreSQLDatabaseConfig(url: pgAddress)
    let postgresconfig = PostgreSQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 5432,
        username: "vapor",
        database: "vapor",
        password: nil
    )
    let postgres = PostgreSQLDatabase(config: postgresconfig)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: postgres, as: .psql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)

}
