//
//  BasicButton.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/03.
//

import SwiftUI

struct BasicButton: View {

    let label: String
    var icon: String? = nil
    let action: () -> Void


    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(label)

                if let name = icon{
                    Image(systemName: name)
                }

            }
            .frame(maxWidth: .infinity)
            .padding(.vertical,16)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .background(
                LinearGradient(colors: [.brandColorLight,.bradColorDark], startPoint: .topTrailing, endPoint: .bottomLeading)
            )
            .clipShape(Capsule())
        }
    }
}

#Preview {
    BasicButton(label:"ボタン"){
        print("ボタン")
    }
}
