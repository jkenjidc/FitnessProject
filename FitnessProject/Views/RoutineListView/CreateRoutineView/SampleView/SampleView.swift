//
//  SampleView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 10/4/24.
//

import SwiftUI

struct SampleView: View {
    @State var viewModel: ViewModel
    init(routine: Routine? = nil) {
        _viewModel = State(initialValue: ViewModel(routine: routine))
    }
    var body: some View {
        Form{
            Section(header: Text("Routine Name"), footer: ErrorFooterView(invalidField: false)
            ){
                TextField("", text: $viewModel.routine.name)
                    .keyboardType(.asciiCapable)
                //                .onChange(of: viewModel.routine.name) { _,_ in
                //                    viewModel.checkRoutineName()
                //                }
            }
        }
    }

}

#Preview {
    SampleView()
}
