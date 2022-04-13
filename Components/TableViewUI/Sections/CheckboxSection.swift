//
//  CheckboxSection.swift
//  
//
//  Created by Maxamilian Litteral on 1/24/20.
//

#if canImport(UIKit)

/// Multiple options selectable
public class CheckboxSection<T: RawRepresentable & CaseIterable & RadioOptionConvertible>: Section where T.RawValue == Int  {
    public init(header: HeaderFooterConfiguration?, value: @escaping ((T) -> Bool), of set: T.Type = T.self, footer: HeaderFooterConfiguration?, didSelectRow: @escaping ((T) -> Void)) {
        let rows = set.allCases.map { row in
            Row.checkboxButton(title: row.title, detail: row.description, value: { value(row) }, didToggle: { _ in
                didSelectRow(row)
            })
        }
        super.init(header: header, rows: rows, footer: footer)
    }
}

#endif
