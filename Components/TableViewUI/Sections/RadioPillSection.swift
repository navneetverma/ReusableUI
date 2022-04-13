//
//  RadioPillSection.swift
//  
//
//  Created by Rob Visentin on 1/20/21.
//

#if canImport(UIKit)

/// Single option selectable
public class RadioPillSection<T: RawRepresentable & CaseIterable & RadioOptionConvertible>: Section where T.RawValue == Int  {
    public init(header: HeaderFooterConfiguration?, value: @escaping (() -> T), of set: T.Type = T.self, footer: HeaderFooterConfiguration?, didSelectRow: @escaping ((T) -> Void)) {
        let rows = set.allCases.map { row in
            Row.radioPillButton(title: row.title, value: { row == value() }, didToggle: { _ in
                didSelectRow(row)
            })
        }
        super.init(header: header, rows: rows, footer: footer)
    }
}

#endif
