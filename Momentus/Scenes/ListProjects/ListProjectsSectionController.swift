//
//  ListProjectsSectionController.swift
//  Momentus
//
//  Created by Guilherme Souza on 02/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import Foundation
import IGListKit
import RxCocoa
import RxSwift

protocol ListProjectSectionControllerDelegate: class {
    func didSelect(item: ListProjectCollectionViewCell.ViewModel)
}

final class ListProjectSectionController: ListSectionController {

    var item: ListProjectCollectionViewCell.ViewModel!

    private weak var delegate: ListProjectSectionControllerDelegate!

    init(delegate: ListProjectSectionControllerDelegate) {
        self.delegate = delegate
    }

    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 96)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: ListProjectCollectionViewCell.reuseID, for: self, at: index) as? ListProjectCollectionViewCell else {
            fatalError()
        }
        cell.configure(with: item)
        return cell
    }

    override func didUpdate(to object: Any) {
        item = object as? ListProjectCollectionViewCell.ViewModel
    }

    override func didSelectItem(at index: Int) {
        delegate.didSelect(item: item)
    }
}
