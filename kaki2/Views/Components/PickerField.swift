//
//  PickerField.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/08.
//

import SwiftUI

struct PickerField: View {
    let title:String
    @Binding var age: Int
    var body: some View {
        VStack(alignment: .leading,spacing:12) {
            HStack{
                Text(title)
                    .foregroundStyle(Color(.darkGray))
                    .fontWeight(.semibold)
                    .font(.footnote)
                Spacer()
                Picker(selection: $age) {
                    ForEach(18..<100){ number in
                        Text("\(number)")
                            .tag(number)
                    }
                } label: {
                    Text("年齢")
                }
                .tint(.black)


            }
            Divider()
        }
    }
}

#Preview {
    PickerField(title: "title",age:.constant(18))
}
