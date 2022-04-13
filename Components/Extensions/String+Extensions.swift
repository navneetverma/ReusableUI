//
//  String+Extensions.swift
//  
//
//  Created by Siddarth Gandhi on 10/27/20.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }

}
