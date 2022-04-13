//
//  CollectionViewDataSource.swift
//  
//
//  Created by Vishwanath Deshmukh on 6/9/20.
//
#if canImport(UIKit)
import UIKit
import Foundation

public class CollectionViewDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    public var sections: [CollectionSection]
    public let cellSpacing: CGFloat
    public var layoutViewModel: LayoutViewModel

    // MARK: - Lifecycle

    public init(_ sections: [CollectionSection], layoutViewModel: LayoutViewModel, cellSpacing: CGFloat) {
        self.sections = sections
        self.layoutViewModel = layoutViewModel
        self.cellSpacing = cellSpacing
        super.init()
    }

    // MARK: - Actions

    public func registerCells(with collectionView: UICollectionView) {
        let cellTypes = sections.flatMap { $0.items }.map { $0.itemType }
        cellTypes.forEach {
            collectionView.register($0, forCellWithReuseIdentifier: $0.identifier)
        }
    }

    public func registerHeaderFooters(with collectionView: UICollectionView) {
        let headerTypes = sections.compactMap { $0.header?.headerFooterType }
        headerTypes.forEach {
            collectionView.register($0, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: $0.cellIdentifier)
        }

        let footerTypes = sections.compactMap { $0.footer?.headerFooterType }
        footerTypes.forEach {
            collectionView.register($0, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: $0.cellIdentifier)
        }
    }

    // MARK: - UICollectionViewDataSources

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerType = section.header else { return UICollectionReusableView() }
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerType.supplementaryViewIdentifier, for: indexPath)
            switch headerType {
            case .view(_, let configuration):
                configuration(headerView)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerType = section.footer else { return UICollectionReusableView() }
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerType.supplementaryViewIdentifier, for: indexPath)
            switch footerType {
            case .view(_, let configuration):
                configuration(footerView)
            }
            return footerView
        default:
            fatalError()
        }
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }
        let section = sections[section]
        return section.items.count
    }

    public func item(at indexPath: IndexPath) -> Item? {
        guard sections.indices.contains(indexPath.section) else { return nil }
        let section = sections[indexPath.section]
        guard section.items.indices.contains(indexPath.row) else { return nil }
        return section.items[indexPath.row]
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = item(at: indexPath) else { fatalError() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellIdentifier, for: indexPath)
        configure(cell, for: item)
        return cell
    }

    public func configure(_ cell: UICollectionViewCell, for item: Item) {
        switch item {
        case let .view(_, configuration, _, _, _, _):
            configuration(cell)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return layoutViewModel.sizeForItemInLayout(collectionView: collectionView)
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) else { return }
        switch item {
        case .view(_, _, let didSelect, _, _, _):
            didSelect?(collectionView, indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) else { return }
        switch item {
        case .view(_, _, _, let didDeselect, _, _):
            didDeselect?(collectionView, indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) else { return }
        switch item {
        case .view(_, _, _, _, let didHighlight, _):
            didHighlight?(collectionView, indexPath)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let item = item(at: indexPath) else { return }
        switch item {
        case .view(_, _, _, _, _, let didUnhighlight):
            didUnhighlight?(collectionView, indexPath)
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellSpacing, left: 0, bottom: self.cellSpacing, right: 0)
    }
}

#endif
