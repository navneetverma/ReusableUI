//
//  SectionAndRows.swift
//  
//
//  Created by Maxamilian Litteral on 12/11/19.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class Section {
    public let header: HeaderFooterConfiguration?
    public let rows: [Row]
    public let footer: HeaderFooterConfiguration?

    public init(header: HeaderFooterConfiguration?, rows: [Row], footer: HeaderFooterConfiguration?) {
        self.header = header
        self.rows = rows
        self.footer = footer
    }
}
#endif
