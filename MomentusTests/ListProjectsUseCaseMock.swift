//
//  ListProjectsUseCaseMock.swift
//  MomentusTests
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

@testable import Momentus

struct ListProjectsUseCaseMock: ListProjectsUseCaseProvider {
    func loadAllProjects() -> Observable<[Project]> {
        let projects = [
            Project(uid: "1", name: "Project 1", tasks: []),
            Project(uid: "2", name: "Project 2", tasks: []),
            Project(uid: "3", name: "Project 3", tasks: [])
        ]
        return Observable.just(projects)
    }
}
