//
//  RowItem+Header.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 12/1/25.
//

import SwiftUI

extension ExercisesSection.RowItem {
    struct Header: View {
        let name: String
        var onDelete: () -> Void
        var body: some View {
            ZStack(alignment: .leading) {
                Button {
                    withAnimation {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                        .padding(.leading, 30)
                }

                Text(name)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
}

#Preview {
    ExercisesSection.RowItem.Header(name: "Test", onDelete: {})
}
