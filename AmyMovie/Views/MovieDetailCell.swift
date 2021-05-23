//
//  MovieDetailCell.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/17/21.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
    let detailLabel: UILabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.lineBreakMode = .byTruncatingTail
        detailLabel.numberOfLines = 2
        contentView.addSubview(detailLabel)
        
        NSLayoutConstraint.activate([
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        detailLabel.text = nil
    }
}
