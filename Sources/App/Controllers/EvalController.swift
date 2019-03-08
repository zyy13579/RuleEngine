//
//  EvalController.swift
//  App
//
//  Created by 赵友源 on 2019/3/8.
//

import Vapor

/// Controls basic CRUD operations on `Todo`s.
final class EvalController {
    /// Returns a list of all `Todo`s.
    func eval(_ req: Request) throws -> Future<[Menu]> {
        return Menu.query(on: req).all()
    }
    
    func caculate(s:String)->Bool{
        let exp:NSExpression = NSExpression(format:s)
        let result:Bool = exp.expressionValue(with: nil,context:nil) as? Bool ?? false
        return result
    }
    
}
