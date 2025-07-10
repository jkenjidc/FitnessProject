//
//  SettingsView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/28/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var bindingPriv = true
    @Bindable var dataManager = DataManager.shared
    var body: some View {
        VStack{
            List {
                HStack {
                    Toggle("Imperial Weight Unit", isOn: $dataManager.user.preferences.usingImperialWeightUnits)
                        .onChange(of: dataManager.user.preferences.usingImperialWeightUnits ) {
                            Task{
                                try await dataManager.switchWeightUnits()
                            }
                        }
                }
            }
            Spacer()
        }
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement:.topBarLeading){
                BackButton()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environment(Router())
}
