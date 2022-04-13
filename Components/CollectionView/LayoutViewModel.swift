//
//  File.swift
//  
//
//  Created by Sindhu Majeti on 6/22/20.
//

#if canImport(UIKit)
import UIKit
import Foundation

public enum LayoutViewType {
    case grid
}

private struct CachedSize {
    let itemSize: CGSize
}

public struct LayoutViewModel {
    let columnCount: CGFloat
    let cellHeight: CGFloat?
    let layoutViewType: LayoutViewType
    let cellSpacing: CGFloat
    private var cachedItemSize: CachedSize?

    public init(columnCount: CGFloat, cellHeight: CGFloat?, layoutViewType: LayoutViewType, cellSpacing: CGFloat) {
        self.columnCount = columnCount
        self.cellHeight = cellHeight
        self.layoutViewType = layoutViewType
        self.cellSpacing = cellSpacing
    }
    
    public mutating func sizeForItemInLayout(collectionView: UICollectionView) -> CGSize {
        switch layoutViewType {
        case .grid:
            let totalSpacing = ((columnCount - 1) * cellSpacing)
            if let cachedSize = cachedItemSize?.itemSize {
                return cachedSize
            } else {
                let width: CGFloat = (collectionView.bounds.width - totalSpacing) / columnCount
                let height: CGFloat = cellHeight ?? width
                let size = CGSize(width: width, height: height)
                cachedItemSize = CachedSize(itemSize: size)
                return size
            }
        }
    }
}
#endif
