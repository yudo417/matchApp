//
//  BrandImage.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/03.
//

import SwiftUI

enum BrandImageSize:CGFloat{
    case large = 120
    case small = 32
}
struct BrandImage: View {

    let size: BrandImageSize

    var body: some View {

        LinearGradient(
            colors: [.brandColorLight,.bradColorDark],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
        .mask {
            Image(systemName: "flame.fill")
                        .resizable()
                        .scaledToFit()
        }
        .frame(width: size.rawValue,height: size.rawValue)

//         Image(systemName: "house")
//            .resizable()
//            .scaledToFit()
//            .foregroundStyle(.red)
//            .frame(width: size.rawValue, height: size.rawValue)
//            .padding(.vertical,32)
    }
}

#Preview {
    BrandImage(size:.large)
}
