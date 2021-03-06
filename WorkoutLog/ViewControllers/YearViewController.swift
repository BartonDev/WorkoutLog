//
//  YearViewController.swift
//  WorkoutLog
//
//  Created by Alec Barton on 7/12/20.
//  Copyright © 2020 Alec Barton. All rights reserved.
//

import UIKit

class YearViewController: UICollectionViewController {
    
    let padding: CGFloat = 30
    var years: [Year] = {
        var array:[Year] = []
        if let year2020 = Year(year: 2020){
            array.append(year2020)
        }
        if let year2021 = Year(year: 2021){
            array.append(year2021)
        }
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TemplateManager.shared.setup()
        
        setup()
        registerIds()
    }
    
    private func setup() {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
        
        view.backgroundColor = ColorTheme.lightGray1
        collectionView.backgroundColor = ColorTheme.lightGray1
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaTopAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func registerIds () {
        collectionView.register(YearHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: YearHeaderView.id)
        collectionView.register(DateCollectionCell.self, forCellWithReuseIdentifier: DateCollectionCell.id)
        
    }
}

extension YearViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return years.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: YearHeaderView.id, for: indexPath) as! YearHeaderView
        header.year = years[indexPath.section]
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 50.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return years[section].numberOfCells
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let year = years[indexPath.section]
        let dayPadding = year.dayOffset
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionCell.id, for: indexPath) as! DateCollectionCell
        if indexPath.row >= dayPadding && indexPath.row < year.daysInYear + dayPadding{
            
            let day = indexPath.row - dayPadding + 1
            let date = Date(year: year.year, day: day)
            cell.date = date
            
            if cell.date?.isToday ?? false {
                cell.backgroundColor = ColorTheme.DateCell.highlight
            } else {
                cell.backgroundColor = ColorTheme.lightGray4
            }
        } else {
            cell.backgroundColor = ColorTheme.lightGray2
            cell.date = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width/14 - 10
        return .init(width: size, height: size)
    }
}

