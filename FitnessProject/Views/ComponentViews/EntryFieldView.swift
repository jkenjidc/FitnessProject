//
//  EntryFieldView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/23/24.
//

import SwiftUI

struct EntryFieldView: View {
    @Binding var textBinding: String
    var placeholderString: String
    var isSecureField: Bool? = false
    var iconImagename: String?
    var body: some View {
        HStack {
            if let imageName = iconImagename {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
//                    .font(.system(size: 20, weight: .regular, design: .monospaced))
            }
            if let showSecureField = isSecureField, !showSecureField {
                TextField(placeholderString, text: $textBinding)
                    
            } else {
                SecureField(placeholderString, text: $textBinding)

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
    @State var sampleTextBinidng = ""
    return EntryFieldView(textBinding: $sampleTextBinidng, placeholderString: "Sample placeholder", isSecureField: true, iconImagename: "envelope.fill")
}
