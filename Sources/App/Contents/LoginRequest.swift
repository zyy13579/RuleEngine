//
//  LoginRequest.swift
//  App
//
//  Created by 赵友源 on 2019/2/11.
//

import Vapor

struct LoginRequest:Content {
    var username: String
    var password: String
}
