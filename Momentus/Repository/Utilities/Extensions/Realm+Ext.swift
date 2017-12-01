//
//  Realm+Ext.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> ()) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        keyPath = sortDescriptor.key ?? ""
        ascending = sortDescriptor.ascending
    }
}

extension Reactive where Base: Realm {
    func save<R: RealmRepresentable>(_ entity: R, update: Bool = true) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entity.asRealm(), update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func save<R: RealmRepresentable>(_ entities: [R], update: Bool = true) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.add(entities.map { $0.asRealm() }, update: update)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func delete<R: RealmRepresentable>(_ entity: R) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.base.write {
                    self.base.delete(entity.asRealm())
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }
}
