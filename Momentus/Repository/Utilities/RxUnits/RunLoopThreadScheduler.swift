//
//  RunLoopThreadScheduler.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

/// RunLoopThreadScheduler is a thread scheduler that runs it's tasks on a Run Loop.
final class RunLoopThreadScheduler: ImmediateSchedulerType {
    private let thread: Thread
    private let target: ThreadTarget

    init(threadName: String) {
        target = ThreadTarget()
        thread = Thread(target: target, selector: #selector(ThreadTarget.threadEntryPoint), object: nil)
        thread.name = threadName
        thread.start()
    }

    func schedule<StateType>(_ state: StateType, action: @escaping (StateType) -> Disposable) -> Disposable {
        let disposable = SingleAssignmentDisposable()
        var action: Action? = Action {
            if disposable.isDisposed {
                return
            }

            disposable.setDisposable(action(state))
        }

        action?.perform(#selector(Action.performAction),
                        on: thread,
                        with: nil,
                        waitUntilDone: false,
                        modes: [RunLoopMode.defaultRunLoopMode.rawValue])

        let actionDisposable = Disposables.create {
            action = nil
        }

        return Disposables.create(disposable, actionDisposable)
    }

    deinit {
        thread.cancel()
    }
}

private final class ThreadTarget: NSObject {
    @objc fileprivate func threadEntryPoint() {
        let runLoop = RunLoop.current
        runLoop.add(NSMachPort(), forMode: RunLoopMode.defaultRunLoopMode)
        runLoop.run()
    }
}

private final class Action: NSObject {
    private let action: () -> ()

    init(action: @escaping () -> ()) {
        self.action = action
    }

    @objc func performAction() {
        action()
    }
}
