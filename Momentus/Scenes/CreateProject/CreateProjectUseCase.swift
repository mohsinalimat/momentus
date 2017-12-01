//
//  CreateProjectUseCase.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol CreateProjectUseCaseProvider {
    func createProject(name: String) -> Observable<Project>
}

struct CreateProjectUseCase: CreateProjectUseCaseProvider {
    private let projectRepository: Repository<Project>

    init(projectRepository: Repository<Project>) {
        self.projectRepository = projectRepository
    }

    func createProject(name: String) -> Observable<Project> {
        let project = Project(uid: UUID().uuidString, name: name, tasks: [])
        return projectRepository.save(project)
            .flatMap { _ in self.projectRepository.query(by: project.uid) }
    }
}
