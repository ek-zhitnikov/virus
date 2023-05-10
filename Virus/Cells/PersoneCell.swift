//
//  View.swift
//  Virus
//
//  Created by Евгений Житников on 05.05.2023.
//

import UIKit

class PersoneCell: UICollectionViewCell {
    private let imageView = UIImageView()
      
      override init(frame: CGRect) {
          super.init(frame: frame)
          contentView.addSubview(imageView)
          imageView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
              imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
          ])
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      var model: PersoneCellModel? {
          didSet {
              if (model?.isInfected ?? false) {
                  imageView.image = UIImage(systemName: "figure.stand")
                  imageView.tintColor = UIColor.systemRed
              } else {
                  imageView.image = UIImage(systemName: "figure.stand")
                  imageView.tintColor = UIColor.systemGreen
              }
          }
      }
}

