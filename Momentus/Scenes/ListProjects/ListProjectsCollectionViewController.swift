//
//  ListProjectsCollectionViewController.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import RxSwift
import IGListKit
import RxCocoa

final class ListProjectsCollectionViewController: UICollectionViewController {

    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    private lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 2)
    }()

    private var viewModel: ListProjectsViewModel!
    private let disposeBag = DisposeBag()
    private let dataSource = DataSource()

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddProjectTap(_:)))
        navigationItem.title = "Projects"
        collectionView?.refreshControl = refreshControl
        adapter.collectionView = collectionView
        adapter.rx.setDataSource(dataSource)
            .disposed(by: disposeBag)
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
            .drive(adapter.rx.item(dataSource: dataSource))
            .disposed(by: disposeBag)

        output.projectSelected
            .drive(onNext: { project in
                print(project.name)
            }).disposed(by: disposeBag)
    }

    @objc private func handleAddProjectTap(_ sender: UIBarButtonItem) {
        let createProjectViewController = CreateProjectViewController.instantiate()
        navigationController?.pushViewController(createProjectViewController, animated: true)
    }

    final class DataSource: NSObject, RxListAdapterDataSource, ListAdapterDataSource, ListProjectSectionControllerDelegate {
        typealias Element = [ListProjectCollectionViewCell.ViewModel]

        private var elements: Element = []

        func listAdapter(_ adapter: ListAdapter, observedElements: Event<[ListProjectCollectionViewCell.ViewModel]>) {
            if case .next(let projects) = observedElements {
                elements = projects
                adapter.performUpdates(animated: true)
            }
        }

        func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
            return elements
        }

        func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
            return ListProjectSectionController(delegate: self)
        }

        func emptyView(for listAdapter: ListAdapter) -> UIView? {
            return nil
        }

        var selectedItem: Driver<ListProjectCollectionViewCell.ViewModel> {
            return selectedItemProperty.asDriverOnErrorJustComplete()
        }

        private let selectedItemProperty = PublishSubject<ListProjectCollectionViewCell.ViewModel>()
        func didSelect(item: ListProjectCollectionViewCell.ViewModel) {
            selectedItemProperty.onNext(item)
        }

    }

}
