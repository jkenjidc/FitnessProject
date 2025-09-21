//
//  SettingsView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/28/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(Router.self) var router
    @Bindable var dataManager = DataManager.shared
    @State var confirmAccountDeletion: Bool = false
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

                Button(role: .destructive) {
                    confirmAccountDeletion.toggle()
                } label: {
                    Text("Delete Account")
                }

               
            }
            Spacer()
        }
        .navigationTitle("Settings")
        .alert("Delete account", isPresented: $confirmAccountDeletion){
            Button("OK", role: (.destructive)){
                Task {
                    await deleteAccount {
                        router.popToRoot()
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete your account? This action can't be reversed")
        }
        .toolbar {
            ToolbarItem(placement:.topBarLeading){
                BackButton()
            }
        }
    }

    func deleteAccount(pop: () -> Void) async {
        pop()
        do {
            try await DataManager.shared.deleteUser()
            try await AuthManager.shared.deleteAccount()
            DataManager.shared.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SettingsView()
        .environment(Router())
}
