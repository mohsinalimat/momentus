//
//  ListProjectCollectionViewCell.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit
import IGListKit

final class ListProjectCollectionViewCell: UICollectionViewCell {

    final class ViewModel: ListDiffable {
        let uid: String
        let name: String
        let totalDuration: TimeInterval
        let project: Project

        init(project: Project) {
            uid = project.uid
            name = project.name
            totalDuration = project.totalDuration
            self.project = project
        }

        func diffIdentifier() -> NSObjectProtocol {
            return uid as NSObjectProtocol
        }

        func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
            if let object = object as? ViewModel {
                return object.uid == uid &&
                    object.name == name &&
                    object.totalDuration == totalDuration
            }
            return false
        }
    }

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        timeLabel.text = nil
    }

    func configure(with viewModel: ViewModel) {
        nameLabel.text = viewModel.name

        let hours = extractHours(from: viewModel.totalDuration)
        timeLabel.text = "\(hours) " + (hours != 1 ? "hours" : "hour")
    }

    private func extractHours(from duration: TimeInterval) -> Int {
        let minutes = duration / 60
        let hours = minutes / 60
        return Int(hours)
    }
}
