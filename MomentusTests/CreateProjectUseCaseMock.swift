//
//  CreateProjectUseCaseMock.swift
//  MomentusTests
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

@testable import Momentus

struct CreateProjectUseCaseMock: CreateProjectUseCaseProvider {
    func createProject(name: String) -> Observable<Project> {
        return Observable.just(Project(uid: "1", name: name, tasks: []))
    }
}
