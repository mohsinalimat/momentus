//
//  RMTask.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RealmSwift

final class RMTask: Object {
    @objc dynamic var uid: String = UUID().uuidString
    @objc dynamic var title: String = ""
    var timeEntries = List<RMTimeEntry>()

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMTask: DomainConvertibleType {
    func asDomain() -> Task {
        return Task(
            uid: uid,
            title: title,
            timeEntries: timeEntries.map { $0.asDomain() }
        )
    }
}

extension Task: RealmRepresentable {
    func asRealm() -> RMTask {
        return RMTask.build { object in
            object.uid = uid
            object.title = title
            object.timeEntries = List(timeEntries.map { $0.asRealm() })
        }
    }
}
