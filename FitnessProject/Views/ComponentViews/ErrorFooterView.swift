//
//  ErrorFooterView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import SwiftUI

struct ErrorFooterView: View {
    var invalidField: Bool
    var errorMessage: String?
    var successType: Bool?
    var body: some View {
        if invalidField {
            Text(errorMessage ?? "Field can't be blank" )
                .font(.subheadline)
                .foregroundStyle(successType ?? false ? .green : .red)
                .opacity(0.8)
        }
    }
}

#Preview {
    ErrorFooterView(invalidField: true, errorMessage: "Sample error message")
}
