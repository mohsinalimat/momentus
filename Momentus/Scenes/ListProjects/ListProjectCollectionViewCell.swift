//
//  ListProjectCollectionViewCell.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class ListProjectCollectionViewCell: UICollectionViewCell {
//
//    struct ViewModel {
//        let name: String
//        let time: Int
//    }

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

    func configure(with project: Project) {
        nameLabel.text = project.name

        let hours = extractHours(from: project.totalDuration)
        timeLabel.text = "\(hours) " + (hours != 1 ? "hours" : "hour")
    }

    private func extractHours(from duration: TimeInterval) -> Int {
        let minutes = duration / 60
        let hours = minutes / 60
        return Int(hours)
    }
}

//extension ListProjectCollectionViewCell.ViewModel: Equatable {
//    static func ==(lhs: ListProjectCollectionViewCell.ViewModel, rhs: ListProjectCollectionViewCell.ViewModel) -> Bool {
//        return lhs.name == rhs.name &&
//            lhs.time == rhs.time
//    }
//}

