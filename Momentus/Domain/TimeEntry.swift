//
//  TimeEntry.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct TimeEntry {
    let uid: String
    let detail: String
    let duration: TimeInterval
    let category: TimeEntryCategory
}
