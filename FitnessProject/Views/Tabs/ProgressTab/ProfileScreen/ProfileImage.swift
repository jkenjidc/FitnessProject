//
//  ProfileImage.swift
//  FitnessProject
//
//  Created by Kenji Dela Cruz on 9/21/25.
//

import SwiftUI
import PhotosUI

struct ProfileImage: View {
    @Binding var selectedItem: PhotosPickerItem?
    let profileImage: Image?
    let loadImageFromPicker: () -> Void
    var body: some View {
        ZStack(alignment: .topTrailing){
            Group {
                if let profilePicture = profileImage {
                    profilePicture
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width:180, height: 180)
            .clipShape(Circle())
            .offset(y: 15)

            PhotosPicker(selection: $selectedItem){
                Image(systemName: "pencil")
                    .font(.system(size: 25))
            }
            .onChange(of: selectedItem, loadImageFromPicker)
            .buttonStyle(.plain)
            .offset(x:5,y:20)
        }

    }
}

#Preview {
    ProfileImage(selectedItem: .constant(nil), profileImage: nil, loadImageFromPicker: {print("test")})
}
