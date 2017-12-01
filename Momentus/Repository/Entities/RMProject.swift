//
//  RMProject.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RealmSwift

final class RMProject: Object {
    @objc dynamic var uid: String = UUID().uuidString
    @objc dynamic var name: String = ""
    var tasks = List<RMTask>()

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMProject: DomainConvertibleType {
    func asDomain() -> Project {
        return Project(
            uid: uid,
            name: name,
            tasks: tasks.map { $0.asDomain() }
        )
    }
}

extension Project: RealmRepresentable {
    func asRealm() -> RMProject {
        return RMProject.build { (object) in
            object.uid = uid
            object.name = name
            object.tasks.append(objectsIn: tasks.map { $0.asRealm() })
        }
    }
}

