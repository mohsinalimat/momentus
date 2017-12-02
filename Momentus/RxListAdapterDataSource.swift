//
//  RxListAdapterDataSource.swift
//  Momentus
//
//  Created by Guilherme Souza on 02/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import IGListKit

protocol RxListAdapterDataSource {
    associatedtype Element
    func listAdapter(_ adapter: ListAdapter, observedElements: Event<Element>)
}

extension Reactive where Base: ListAdapter {
    func item<DataSource: RxListAdapterDataSource & ListAdapterDataSource, O: ObservableType>(dataSource: DataSource)
        -> (_ source: O)
        -> Disposable where DataSource.Element == O.E {

            return { source in
                let subscription = source
                    .subscribe { dataSource.listAdapter(self.base, observedElements: $0) }

                return Disposables.create {
                    subscription.dispose()
                }
            }
    }

    func setDataSource<DataSource: RxListAdapterDataSource & ListAdapterDataSource>(_ dataSource: DataSource) -> Disposable {
        base.dataSource = dataSource
        return Disposables.create()
    }
}

