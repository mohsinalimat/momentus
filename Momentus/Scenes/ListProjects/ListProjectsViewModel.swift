//
//  ListProjectsViewModel.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct ListProjectsViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Driver<Void>
    }
    struct Output {
        let projects: Driver<[Project]>
    }

    private let listProjectsUseCase: ListProjectsUseCaseProvider

    init(listProjectsUseCase: ListProjectsUseCaseProvider) {
        self.listProjectsUseCase = listProjectsUseCase
    }

    func transform(input: ListProjectsViewModel.Input) -> ListProjectsViewModel.Output {
        let projects = input.viewWillAppear.flatMapLatest { _ in
            return self.listProjectsUseCase.loadAllProjects()
                .asDriverOnErrorJustComplete()
        }
        return Output(projects: projects)
    }
}