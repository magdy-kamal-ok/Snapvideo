//
//  LooksViewController.swift
//  Snapvideo
//
//  Created by Anastasia Petrova on 07/02/2020.
//  Copyright © 2020 Anastasia Petrova. All rights reserved.
//

import UIKit

final class LooksViewController: UIViewController {
    typealias Callback = (Int, Int) -> Void
    
    let dataSource: LooksCollectionDataSource
    let collectionView: UICollectionView
    let filterIndexChangeCallback: Callback
    var selectedFilterIndex = 0
    var selectedFilter: AnyFilter {
        dataSource.filters[selectedFilterIndex]
    }

    convenience init(itemSize: CGSize, filters: [AnyFilter], callback: @escaping Callback) {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: LooksCollectionViewLayout(itemSize: itemSize)
        )
        self.init(itemSize: itemSize, filters: filters, collectionView: collectionView, callback: callback)
    }
    
    init(itemSize: CGSize, filters: [AnyFilter], collectionView: UICollectionView, callback: @escaping Callback) {
        filterIndexChangeCallback = callback
        self.collectionView = collectionView
        self.dataSource = LooksCollectionDataSource(
            collectionView: collectionView,
            filters: filters,
            context: CIContext(options: [CIContextOption.workingColorSpace : NSNull()])
        )
        super.init(nibName: nil, bundle: nil)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsSelection = true
        collectionView.bounces = false
        
        NSLayoutConstraint.activate ([
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func deselectFilter() {
        collectionView.deselectItem(at: IndexPath(item: selectedFilterIndex, section: 0), animated: false)
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}

extension LooksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedFilterIndex
        selectedFilterIndex = indexPath.row
        
        filterIndexChangeCallback(selectedFilterIndex, previousIndex)
        
        if selectedFilterIndex != 0 {
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
