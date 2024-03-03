//
//  DateFormatter+Extensions.swift
//  BeReal
//
//  Created by Jose Baez on 10/11/23.
//

import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}
