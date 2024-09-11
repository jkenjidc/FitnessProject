//
//  RoutineListCellView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/11/24.
//

import SwiftUI

struct RoutineListCellView: View {
    var title: String
    @State private var isExpanded = false
    var body: some View {
        VStack(alignment: .leading){
            Button{
                withAnimation(.linear(duration: 0.3)){
                    isExpanded.toggle()
                }
            } label: {
                if !isExpanded {
                    Text(title)
                } else {
                    VStack(alignment: .leading){
                        Text(title)
                        Image(systemName: "list.bullet.rectangle.portrait.fill")
                            .resizable()
                            .frame(width: 100, height:150)
                    }
                }
            }
            .buttonStyle(.plain)
        }
//        DisclosureGroup(
//            isExpanded: $isExpanded,
//            content: {
//                VStack(alignment: .leading){
//                    Text(title)
//                    Image(systemName: "list.bullet.rectangle.portrait.fill")
//                        .resizable()
//                        .frame(width: 100, height:150)
//                }
//            },
//            label: {
//                Text(title)
//            }
//        )
        .padding()
    }
}

#Preview {
    RoutineListCellView(title: "Routine 1")
}
