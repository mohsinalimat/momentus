//
//  CreateProjectViewModel.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct CreateProjectViewModel: ViewModelType {
    struct Input {
        let confirmTapped: Driver<Void>
        let viewDidAppear: Driver<Void>

        let projectName: Driver<String>
    }

    struct Output {
        let nameTextFieldBecomeFirstResponder: Driver<Void>
        let projectCreated: Driver<Void>
    }

    private let useCase: CreateProjectUseCaseProvider

    init(useCase: CreateProjectUseCaseProvider) {
        self.useCase = useCase
    }

    func transform(input: CreateProjectViewModel.Input) -> CreateProjectViewModel.Output {
        let nameTextFieldBecomeFirstResponder = input.viewDidAppear
        let projectCreated = input.confirmTapped.withLatestFrom(input.projectName)
            .flatMapLatest { name in
                return self.useCase.createProject(name: name)
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
        }

        return Output(
            nameTextFieldBecomeFirstResponder: nameTextFieldBecomeFirstResponder,
            projectCreated: projectCreated
        )
    }

}
