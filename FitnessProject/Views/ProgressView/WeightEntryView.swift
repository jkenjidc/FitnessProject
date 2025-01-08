//
//  WeightEntryView.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 1/8/25.
//

import SwiftUI

struct WeightEntryView: View {
    @Binding var presentEntryView: Bool
    @State private var scale = 0.0
    @Binding var selectedDate: Date
    @Binding var currentWeight: String
    let action: (() -> Void)
    var body: some View {
        ZStack {
            Color(.gray)
                .opacity(0.2)
                .onTapGesture {
                    close()
                }
            VStack{
                Text("Add Weight Entry")
                    .font(.title2)
                    .bold()
                    .padding()
                    .foregroundStyle(.white)
                
                HStack {
                    EntryFieldView(textBinding: $currentWeight, placeholderString: "Enter Weight")
                    DatePicker("", selection: $selectedDate,in: ...Date.now , displayedComponents: [.date])
                        .foregroundStyle(.white)
                        .colorScheme(.dark)
                        .buttonStyle(.plain)
                }
                ZStack{
                    Button {
                        close()
                        action()
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Log Weight")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                        .padding()
                }
                .padding()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay {
                VStack{
                    HStack{
                        Button {
                            close()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .tint(.white)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .shadow(radius: 20)
            .padding(30)
            .scaleEffect(scale)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.linear(duration: 0.2)) {
                scale = 1.0
            }
            
        }
    }
    
    func close() {
        withAnimation(.linear(duration: 0.15)) {
            scale = 0.0
            presentEntryView = false
        }
    }
}


#Preview {
    WeightEntryView(presentEntryView: .constant(true), selectedDate: .constant(Date.now), currentWeight: .constant("")){
        print("test")
    }
        .preferredColorScheme(.dark)
}
