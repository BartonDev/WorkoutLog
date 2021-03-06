//
//  ExerciseAddSetCell.swift
//  WorkoutLog
//
//  Created by Alec Barton on 6/14/20.
//  Copyright © 2020 Alec Barton. All rights reserved.
//

import UIKit

protocol AddSetCollectionCellDelegate {
    func addSetCellTapped (_ cell: AddSetCollectionCell)
}

class AddSetCollectionCell: UICollectionViewCell {
    static let id = "AddSetCellId"
    static let cellSize: CGFloat = 35.0
    
    var delegate: AddSetCollectionCellDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.backgroundColor = ColorTheme.lightGray1
        
        self.layer.borderColor = ColorTheme.lightGray4.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func tapped( _ sender: Any) {
        delegate?.addSetCellTapped(self)
    }
    
    static func size() -> CGSize {
        return CGSize(width: AddSetCollectionCell.cellSize, height: AddSetCollectionCell.cellSize)
    }
}
