//
//  ListProjectsUseCase.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import RxSwift

protocol ListProjectsUseCaseProvider {
    func loadAllProjects() -> Observable<[Project]>
}
