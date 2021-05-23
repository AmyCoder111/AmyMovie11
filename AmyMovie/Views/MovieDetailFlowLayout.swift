//
//  MovieDetailFlowLayout.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/17/21.
//

import UIKit

class MovieDetailRowCalculator {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }
    
    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }
    
    func detailLabelLayout() {
        let padding = 10
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}

class MovieDetailFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var movieDetailRows = [MovieDetailRowCalculator]()
        var currentRowY: CGFloat = -1
        
        for attribute in attributes {
            if currentRowY != attribute.frame.origin.y {
                currentRowY = attribute.frame.origin.y
                //Create rows
                movieDetailRows.append(MovieDetailRowCalculator(spacing: 10))
            }
            
            //Add cell attribute to last row
            movieDetailRows.last?.add(attribute: attribute)
        }
        
        movieDetailRows.forEach { $0.detailLabelLayout() }
        return movieDetailRows.flatMap { $0.attributes }
    }
}
