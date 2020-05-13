//
//  ListHeaderFooterController.swift
//  letsMeet
//
//  Created by aisenur on 10.05.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit

open class ListHeaderFooterController<T: ListCell<U>, U, H: UICollectionReusableView, F: UICollectionReusableView>: UICollectionViewController {
    
    var data = [U]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    fileprivate let cellId = "cellId"
    fileprivate let additionalViewId = "additionalViewId"
    
    func setCellHeight(indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let cell = T()
        let height: CGFloat = 1000
        
        cell.frame = .init(x: 0, y: 0, width: cellWidth, height: height)
        
        cell.data = data[indexPath.row]
        cell.layoutIfNeeded()
        return cell.systemLayoutSizeFitting(.init(width: cellWidth, height: height)).height
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        //Tip tanımlama işlemi
        collectionView.register(T.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(H.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: additionalViewId)
         collectionView.register(F.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: additionalViewId)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! T
        cell.data = data[indexPath.row]
        cell.controllerToAdd = self
        
        return cell
    }
    
    open func setHeader() {
        
    }
    
    open func setFooter() {
        
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let additionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: additionalViewId, for: indexPath)
        
        if let _ = additionView as? H {
            setHeader()
        } else if let _ = additionView as? F {
            setFooter()
        }
        
        return additionView
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        view.layer.zPosition = -1 //header ve footer'ı collectionview dışında göstermek istemediğim için -1
    }
    
    public init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        
        super.init(collectionViewLayout: layout)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
