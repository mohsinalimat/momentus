//
//  CreateProjectViewController.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class CreateProjectViewController: UIViewController {

    private enum Constants {
        static let defaultConfirmButtonBottomMargin: CGFloat = 32
    }

    // MARK: Outlets

    @IBOutlet private weak var projectNameTextField: UITextField!
    @IBOutlet private weak var confirmButton: FABButon!
    @IBOutlet private weak var confirmButtonBottomConstraint: NSLayoutConstraint!

    // MARK: Private properties

    private var viewModel: CreateProjectViewModel!
    private let disposeBag = DisposeBag()

    // MARK: Init / Deinit

    static func instantiate() -> UIViewController {
        guard let controller = UIStoryboard.createProject.instantiateInitialViewController() as? CreateProjectViewController else {
            fatalError()
        }
        controller.viewModel = CreateProjectViewModel(
            useCase: CreateProjectUseCase(projectRepository: Repository<Project>())
        )
        return controller
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: View Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToView()
        addKeyboardNotifications()
        bindViewModel()
    }

    // MARK: View Model interations
    private func bindViewModel() {

        let input = CreateProjectViewModel.Input(
            confirmTapped: confirmButton.rx.tap.asDriver(),
            viewDidAppear: rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:))).mapToVoid().asDriverOnErrorJustComplete(),
            projectName: projectNameTextField.rx.text.orEmpty.asDriver()
        )

        let output = viewModel.transform(input: input)

        output.nameTextFieldBecomeFirstResponder
            .drive(onNext: { _ in
                self.projectNameTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        output.projectCreated
            .drive(onNext: { _ in
                print("Project created")
            })
            .disposed(by: disposeBag)

    }

    // MARK: View Tap Gesture

    private func addTapGestureToView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true) // hide keyboard
    }

    // MARK: Keyboard Observer

    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            view.layoutIfNeeded()
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.confirmButtonBottomConstraint.constant = Constants.defaultConfirmButtonBottomMargin + keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardAnimationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
            view.layoutIfNeeded()
            UIView.animate(withDuration: keyboardAnimationDuration) {
                self.confirmButtonBottomConstraint.constant = Constants.defaultConfirmButtonBottomMargin
                self.view.layoutIfNeeded()
            }
        }
    }
}
