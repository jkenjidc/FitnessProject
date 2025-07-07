//
//  ModalModifier.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 7/7/25.
//

import Foundation
import SwiftUI

struct ModalViewModifier<Item: Identifiable, ModalContent: View>: ViewModifier {
    @Binding var item: Item?
    @State private var scale = 0.0
    @Environment(Router.self) var router
    let modalContent: (Item) -> ModalContent

    func body(content: Content) -> some View {
        ZStack {
            content
            if let item {
                ZStack {
                    Color(.gray)
                        .opacity(0.2)
                        .onTapGesture {
                            router.dismissModal()
                        }
                    modalContent(item)
                }
                .ignoresSafeArea()

            }
        }
    }
}

extension View {
    func modal<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        self.modifier(ModalViewModifier(item: item, modalContent: content))
    }
}
