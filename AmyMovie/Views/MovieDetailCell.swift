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

class MovieGenreDetailCell: MovieDetailCell {
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.systemBlue
    }
}

//class MovieGenreDetailCell: UICollectionViewCell {
//    @IBOutlet var genreLabel: UILabel!
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.layer.borderColor = UIColor.gray.cgColor
//        self.layer.borderWidth = 1
//    }
//}

class MovieCompanyDetailCell: MovieDetailCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.orange
    }
}
