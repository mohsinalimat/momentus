//
//  RMTimeEntry.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RealmSwift

final class RMTimeEntry: Object {
    @objc dynamic var uid: String = UUID().uuidString
    @objc dynamic var detail: String = ""
    @objc dynamic var duration: TimeInterval = 0
    @objc dynamic private var _category: String = TimeEntryCategory.other.rawValue

    var category: TimeEntryCategory {
        get {
            return TimeEntryCategory(rawValue: _category) ?? .other
        }
        set {
            _category = newValue.rawValue
        }
    }

    override class func primaryKey() -> String? {
        return "uid"
    }
}

extension RMTimeEntry: DomainConvertibleType {
    func asDomain() -> TimeEntry {
        return TimeEntry(
            uid: uid,
            detail: detail,
            duration: duration,
            category: category
        )
    }
}

extension TimeEntry: RealmRepresentable {
    func asRealm() -> RMTimeEntry {
        return RMTimeEntry.build { object in
            object.uid = uid
            object.detail = detail
            object.duration = duration
            object.category = category
        }
    }
}

enum TimeEntryCategory: String {
    case development
    case design
    case meeting
    case tests
    case other
}
