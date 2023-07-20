//
//  CatsCollectionViewCell.swift
//  Cats
//
//  Created by admin on 20/07/23.
//

import UIKit

class CatsCollectionViewCell: UICollectionViewCell {
    
    //ImageView
    
    var cellImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //Setup Cell
    
    private func setupViews() {
        cellImageView = UIImageView(frame: contentView.bounds)
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.clipsToBounds = true
        cellImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.addSubview(cellImageView)
    }
    
    private func setupConstraints() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
