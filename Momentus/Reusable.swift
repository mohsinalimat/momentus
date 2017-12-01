//
//  Reusable.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String { get }
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}

extension UICollectionView {
    func dequeueReusableCell<T: Reusable>(of type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("could not dequeue cell with reuse identifier '\(T.reuseID)'")
        }
        return cell
    }
}
