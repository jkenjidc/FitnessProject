//
//  EntryFieldView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import SwiftUI

enum KeyboardType {
    case text
    case secure
    case numeric
}

struct EntryFieldView: View {
    @Binding var textBinding: String
    @State var value: Double = 0
    var placeholderString: String
    var keyboardType: KeyboardType?
    var iconImagename: String?
    
    var body: some View {
        HStack {
            if let imageName = iconImagename {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            let keyboardType = keyboardType ?? .text
            switch keyboardType {
            case .text:
                TextField(placeholderString, text: $textBinding)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            case .secure:
                SecureField(placeholderString, text: $textBinding)
            case .numeric:
                TextField("0", value: $value, format: .number)
                    .keyboardType(.decimalPad)

            }
        }
        .padding()
        .overlay (
            RoundedRectangle(cornerRadius: 16)
                .stroke(.secondary)
        )
    }
}

#Preview {
    EntryFieldView(textBinding: .constant("Test"), placeholderString: "Sample placeholder", keyboardType: .text, iconImagename: "envelope.fill")
}
