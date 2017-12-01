//
//  Task.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct Task {
    let uid: String
    let title: String
    let timeEntries: [TimeEntry]

    var totalDuration: TimeInterval {
        return timeEntries.reduce(0) { $0 + $1.duration }
    }
}
