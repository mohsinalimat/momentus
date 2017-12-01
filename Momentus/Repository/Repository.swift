//
//  Repository.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RxRealm
import RealmSwift

private func abstractMethod() -> Never {
    fatalError("abstract method")
}

class AbstractRespository<T> {
    func queryAll() -> Observable<[T]> {
        abstractMethod()
    }

    func query(by id: String) -> Observable<T> {
        abstractMethod()
    }

    func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        abstractMethod()
    }

    func save(_ entity: T) -> Observable<Void> {
        abstractMethod()
    }

    func saveCollection(_ entities: [T]) -> Observable<Void> {
        abstractMethod()
    }

    func delete(_ entity: T) -> Observable<Void> {
        abstractMethod()
    }
}

final class Repository<T: RealmRepresentable>: AbstractRespository<T> where T == T.RealmType.DomainType, T.RealmType: Object {

    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration) {
        self.configuration = configuration
        let name = "com.grsouza.Momentus.Repository"
        scheduler = RunLoopThreadScheduler(threadName: name)
        print("File 📁 url: \(RLMRealmPathForFile("default.realm"))")
    }

    override func queryAll() -> Observable<[T]> {
        return Observable.deferred {
            let objects = self.realm.objects(T.RealmType.self)
            return Observable.array(from: objects)
                .mapToDomain()
            }
            .subscribeOn(scheduler)
    }

    override func query(by id: String) -> Observable<T> {
        return Observable.deferred {
            let object = self.realm.object(ofType: T.RealmType.self, forPrimaryKey: id)?.asDomain()
            return Observable.from(optional: object)
            }
            .subscribeOn(scheduler)
    }

    override func query(with predicate: NSPredicate, sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        return Observable.deferred {
            let objects = self.realm.objects(T.RealmType.self)
                .filter(predicate)
                .sorted(by: sortDescriptors.map(SortDescriptor.init))

            return Observable.array(from: objects)
                .mapToDomain()
            }
            .subscribeOn(scheduler)
    }

    override func save(_ entity: T) -> Observable<Void> {
        return Observable.deferred { self.realm.rx.save(entity) }
            .subscribeOn(scheduler)
    }

    override func saveCollection(_ entities: [T]) -> Observable<Void> {
        return Observable.deferred { self.realm.rx.save(entities) }
            .subscribeOn(scheduler)
    }

    override func delete(_ entity: T) -> Observable<Void> {
        return Observable.deferred { self.realm.rx.delete(entity) }
            .subscribeOn(scheduler)
    }

}
