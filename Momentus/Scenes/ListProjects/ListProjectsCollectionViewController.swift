//
//  ListProjectsCollectionViewController.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift

final class ListProjectsCollectionViewController: UICollectionViewController {

    private var viewModel: ListProjectsViewModel!
    private let disposeBag = DisposeBag()

    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()

    static func instantiate() -> UIViewController {
        guard let controller = UIStoryboard.listProjects.instantiateInitialViewController() as? ListProjectsCollectionViewController else {
            fatalError()
        }
        controller.viewModel = ListProjectsViewModel(listProjectsUseCase: ListProjectsUseCase())
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()

        collectionView?.refreshControl = refreshControl
    }

    private func bindViewModel() {
        let input = ListProjectsViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).asDriverOnErrorJustComplete().mapToVoid(),
            pullToRefresh: refreshControl.rx.controlEvent(.valueChanged).asDriver(),
            selectItemAtIndex: collectionView!.rx.itemSelected.map { $0.row }.asDriverOnErrorJustComplete()
        )

        let output = viewModel.transform(input: input)

        output.projects
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .drive(collectionView!.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(item: row, section: 0)
                let cell = collectionView.dequeueReusableCell(of: ListProjectCollectionViewCell.self, for: indexPath)
                cell.configure(with: element)
                return cell
            }
            .disposed(by: disposeBag)

        output.projectSelected
            .drive(onNext: { project in
                print(project.name)
            }).disposed(by: disposeBag)
    }

}
