//
//  InputField.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/03.
//

import SwiftUI

struct InputField: View {
    @Binding var text: String
    let label: String
    let placeholder: String
    var isSecureField = false
    var withDivider: Bool = true
    var isVertical = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading,spacing: 12){
            Text(label)
                .foregroundStyle(Color(.darkGray))
                .fontWeight(.semibold)
                .font(.footnote)
            if isSecureField {
                SecureField(placeholder, text: $text)
            }else{
                TextField(placeholder, text: $text, axis: isVertical ? .vertical: .horizontal)
                    .textInputAutocapitalization(.never)
                    .keyboardType(keyboardType)

            }
            if withDivider {
                Divider()
            }
        }
    }
}

#Preview {
    InputField(text: .constant(""), label: "メールアドレス", placeholder: "入力してください")
}
