//
//  EquatableArray.swift
//  MomentusTests
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation

struct EquatableArray<Element: Equatable> : Equatable {
    let elements: [Element]
    init(_ elements: [Element]) {
        self.elements = elements
    }
}

func ==<E>(lhs: EquatableArray<E>, rhs: EquatableArray<E>) -> Bool {
    return lhs.elements == rhs.elements
}
