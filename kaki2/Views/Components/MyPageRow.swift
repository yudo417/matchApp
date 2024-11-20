//
//  MyPageRow.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/07.
//

import SwiftUI

struct MyPageRow: View {

    let iconName : String
    let label : String
    let tintColor : Color
    var value : String? = nil

    var body: some View {
        HStack(spacing:16){
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundStyle(tintColor)
            Text(label)
                .foregroundStyle(.black)
            if let value = value{
                Spacer()


                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}

#Preview {
    MyPageRow(iconName: "gear", label: "ええなぁ", tintColor: .red,value: "1.0.0")
}
