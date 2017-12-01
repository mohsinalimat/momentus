//
//  FABButon.swift
//  Momentus
//
//  Created by Guilherme Souza on 01/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

final class FABButon: UIButton {

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 64, height: 64)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        imageView?.contentMode = .scaleAspectFit
        backgroundColor = .black
        layer.cornerRadius = 32

        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.8
    }
}
