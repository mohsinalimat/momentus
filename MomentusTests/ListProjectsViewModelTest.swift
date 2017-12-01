//
//  ListProjectsViewModelTest.swift
//  MomentusTests
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import Momentus

class ListProjectsViewModelTest: XCTestCase {

    var testScheduler: TestScheduler!
    var sut: ListProjectsViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        testScheduler = TestScheduler(initialClock: 0)
        sut = ListProjectsViewModel(listProjectsUseCase: ListProjectsUseCaseMock())
        disposeBag = DisposeBag()
    }
    
    func test_shouldLoadProjects_whenViewWillAppear() {
        let viewWillAppear = testScheduler.createHotObservable([next(100, ())])
        let input = ListProjectsViewModel.Input(
            viewWillAppear: viewWillAppear.asDriverOnErrorJustComplete()
        )
        let output = sut.transform(input: input)
        let observer = testScheduler.createObserver(EquatableArray<Project>.self)
        output.projects
            .map { EquatableArray($0) }
            .drive(observer)
            .disposed(by: disposeBag)

        testScheduler.start()

        let projects = [
            Project(uid: "1", name: "Project 1", tasks: []),
            Project(uid: "2", name: "Project 2", tasks: []),
            Project(uid: "3", name: "Project 3", tasks: [])
        ]
        let expected = [
            next(100, EquatableArray(projects))
        ]

        XCTAssertEqual(observer.events, expected)
    }

}
