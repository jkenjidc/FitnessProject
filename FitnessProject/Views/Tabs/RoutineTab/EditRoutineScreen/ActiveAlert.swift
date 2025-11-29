//
//  ActiveAlert.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 11/28/25.
//

import Foundation

struct ActiveAlert {
    let title: String
    let message: String
    let primaryButtonTitle: String
    let primaryButtonAction: () -> Void
    let primaryButtonRole: AlertTypeV2

    init(
        title: String,
        message: String,
        primaryButtonTitle: String,
        primaryButtonAction: @escaping () -> Void,
        primaryButtonRole: AlertTypeV2 = .normal
    ) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryButtonAction = primaryButtonAction
        self.primaryButtonRole = primaryButtonRole
    }
}
