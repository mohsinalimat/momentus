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
        let pullToRefresh: Driver<Void>
        let selectItemAtIndex: Driver<Int>
    }
    struct Output {
        let projects: Driver<[ListProjectCollectionViewCell.ViewModel]>
        let projectSelected: Driver<ListProjectCollectionViewCell.ViewModel>
    }

    private let listProjectsUseCase: ListProjectsUseCaseProvider

    init(listProjectsUseCase: ListProjectsUseCaseProvider) {
        self.listProjectsUseCase = listProjectsUseCase
    }

    func transform(input: ListProjectsViewModel.Input) -> ListProjectsViewModel.Output {
        let projects = Driver.merge(input.viewWillAppear, input.pullToRefresh)
            .flatMapLatest { _ in
                return self.listProjectsUseCase.loadAllProjects()
                    .map { $0.map(ListProjectCollectionViewCell.ViewModel.init) }
                    .asDriverOnErrorJustComplete()
        }

        let projectSelected = input.selectItemAtIndex.withLatestFrom(projects) { (index, projects) -> ListProjectCollectionViewCell.ViewModel in
            return projects[index]
        }

        return Output(
            projects: projects,
            projectSelected: projectSelected
        )
    }
}
