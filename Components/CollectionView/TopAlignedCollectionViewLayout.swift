//
//  TopAlignedColelctionViewLayout.swift
//  
//
//  Created by Rob Visentin on 3/31/21.
//

#if canImport(UIKit)
import UIKit

public final class TopAlignedCollectionViewLayout: UICollectionViewFlowLayout {

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let allAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let cellAttributes = allAttributes.filter { $0.representedElementCategory == .cell }
        let lines = Dictionary(grouping: cellAttributes) { round($0.center.y) }.values

        for line in lines {
            let minY = floor(line.min(by: { $0.frame.minY < $1.frame.minY })?.frame.minY ?? 0)
            line.forEach { $0.frame.origin.y = minY }
        }

        return allAttributes
    }

}
#endif
