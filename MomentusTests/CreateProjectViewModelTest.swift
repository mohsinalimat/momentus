//
//  CreateProjectViewModelTest.swift
//  MomentusTests
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest

@testable import Momentus

class CreateProjectViewModelTest: XCTestCase {

    var testScheduler: TestScheduler!
    var sut: CreateProjectViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        testScheduler = TestScheduler(initialClock: 0)
        sut = CreateProjectViewModel(useCase: CreateProjectUseCaseMock())
        disposeBag = DisposeBag()
    }

    func test_projectNameTextFieldShouldBecomeFirstResponder_whenViewDidApper() {
        let viewDidAppear = testScheduler.createHotObservable([next(100, ())])
        let input = CreateProjectViewModel.Input(
            confirmTapped: Driver.empty(),
            viewDidAppear: viewDidAppear.asDriverOnErrorJustComplete(),
            projectName: Driver.empty()
        )
        let output = sut.transform(input: input)
        let observer = testScheduler.createObserver(Void.self)
        output.nameTextFieldBecomeFirstResponder
            .drive(observer)
            .disposed(by: disposeBag)

        testScheduler.start()

        let expected = [
            next(100, ())
        ]

        // testing events count because Void is not equatable.
        XCTAssertEqual(observer.events.count, expected.count)
    }

    func test_shouldCreateProject_whenConfirmIsTapped() {
        let confirmTapped = testScheduler.createHotObservable([next(100, ())])
        let input = CreateProjectViewModel.Input(
            confirmTapped: confirmTapped.asDriverOnErrorJustComplete(),
            viewDidAppear: Driver.empty(),
            projectName: Driver.just("Project name")
        )
        let output = sut.transform(input: input)
        let observer = testScheduler.createObserver(Void.self)
        output.projectCreated
            .drive(observer)
            .disposed(by: disposeBag)

        testScheduler.start()

        let expected = [
            next(100, ())
        ]

        // testing events count because Void is not equatable.
        XCTAssertEqual(observer.events.count, expected.count)
    }

}
