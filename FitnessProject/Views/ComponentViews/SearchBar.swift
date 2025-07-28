//
//  SearchBar.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/27/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    SearchBar(text: .constant("test"), placeholder: "Search")
}
