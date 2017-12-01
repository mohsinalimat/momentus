//
//  Project.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Project {
    let uid: String
    let name: String
    let tasks: [Task]
}

extension Project: Equatable {
    static func ==(lhs: Project, rhs: Project) -> Bool {
        return lhs.uid == rhs.uid
    }
}

