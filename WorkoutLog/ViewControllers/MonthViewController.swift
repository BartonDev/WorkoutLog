//
//  ViewController.swift
//  WorkoutLog
//
//  Created by Alec Barton on 4/23/20.
//  Copyright © 2020 Alec Barton. All rights reserved.
//

import UIKit
import Foundation

class MonthViewController: UICollectionViewController {

    let cellSpacing: CGFloat = 4.0
    let padding: CGFloat = 30.0
    var months: [Month] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TemplateManager.shared.setup()
        
        setup()
        registerIds()
        
        for i in 1...12 {
            if let month = Month(month: i, year: 2020) {
                months.append(month)
            }
        }
    }
    
    private func setup() {
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: 0.0, left: padding, bottom: padding, right: padding)
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
        collectionView.register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MonthHeaderView.id)
        
        collectionView.register(WeekdayCollectionCell.self, forCellWithReuseIdentifier: WeekdayCollectionCell.id)
        collectionView.register(DateCollectionCell.self, forCellWithReuseIdentifier: DateCollectionCell.id)
    }
}

extension MonthViewController: UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return months.count
    }
        
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MonthHeaderView.id, for: indexPath) as! MonthHeaderView
        header.month = months[indexPath.section]
        header.year = Year(year: 2020)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 100.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months[section].numberOfCells + 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCollectionCell.id, for: indexPath) as! WeekdayCollectionCell
            cell.day = WeekdayName(rawValue: indexPath.row + 1)
            cell.backgroundColor = ColorTheme.lightGray2
            return cell 
        } else {
            let month = months[indexPath.section]
            let dayPadding = (month.startingDay.rawValue) + 6
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DateCollectionCell.id, for: indexPath) as! DateCollectionCell
            cell.delegate = self
            if indexPath.row >= dayPadding && indexPath.row < month.daysInMonth + dayPadding{
                let date = Date(year: 2020, month: indexPath.section + 1, dayOfMonth: indexPath.row - dayPadding + 1)
                cell.date = date
                if cell.date?.isToday ?? false {
                    cell.backgroundColor = ColorTheme.DateCell.highlight
                } else {
                    cell.backgroundColor = ColorTheme.lightGray4
                }
            } else {
                cell.backgroundColor = ColorTheme.lightGray2
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width - 60 - cellSpacing * 7) / 7
        
        if indexPath.row < 7 {
            return .init(width: size, height: 30.0)
        } else {
            return .init(width: size, height: size)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //TODO: Re-adjust this
        return cellSpacing
    }
}

extension MonthViewController: DateCollectionCellDelegate {
    func cellTapped(_ cell: DateCollectionCell) {
        let viewController = DayViewController()
        self.present(viewController, animated: true)
    }
}

