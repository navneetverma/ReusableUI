//
//  RadioSection.swift
//  
//
//  Created by Maxamilian Litteral on 1/23/20.
//

#if canImport(UIKit)

/// Single option selectable
public class RadioSection<T: RawRepresentable & CaseIterable & RadioOptionConvertible>: Section where T.RawValue == Int  {
    public init(header: HeaderFooterConfiguration?, value: @escaping (() -> T), of set: T.Type = T.self, footer: HeaderFooterConfiguration?, didSelectRow: @escaping ((T) -> Void)) {
        let rows = set.allCases.map { row in
            Row.radioButton(title: row.title, detail: row.description, value: { row == value() }, didToggle: { _ in
                didSelectRow(row)
            })
        }
        super.init(header: header, rows: rows, footer: footer)
    }
}

#endif
