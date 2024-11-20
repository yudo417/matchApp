//
//  RegistrationView.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/03.
//

import SwiftUI

struct RegistrationView: View {

//    let authViewModel : AuthViewModel
    @EnvironmentObject var authViewModel:AuthViewModel
    @State private var email = ""
    @State private var name = ""
    @State private var age = 20
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack{
                
                // Image
                BrandImage(size:.large)
                    .padding(.vertical,32)
                // Form
                VStack(spacing:24){
                    InputField(text: $email, label: "メールアドレス", placeholder: "入力してください", keyboardType: .emailAddress)

                    InputField(text: $name, label: "お名前", placeholder: "入力してください")
                    VStack(alignment: .leading,spacing:12) {
                        HStack{
                            Text("年齢")
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
                    
                    InputField(text: $password, label: "パスワード", placeholder: "半角英数字6文字以上", isSecureField: true)
                    
                    InputField(text: $confirmPassword, label: "パスワード(確認用)", placeholder: "もう一度入力してください", isSecureField: true)
                }
                .padding(.bottom,10)
                // Button
                
                BasicButton(label: "会員登録", icon: "arrow.right")  {
                    Task{
                        await authViewModel.createAccount(email: email, password: password,name: name, age: age)
                    }
                }
                .padding(.top,24)
                
                
                Spacer()
                // Navigation
                
                NavigationLink{
                    
                }label:{
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Text("既にアカウントをお持ちの方")
                            Text("ログイン")
                                .fontWeight(.bold)
                        }
                        
                    }
                    .foregroundStyle(Color(.darkGray))
                }
                .navigationTitle("登録画面")
                .navigationBarTitleDisplayMode(.inline)
            }
            .padding(.horizontal,15)
        }


    }
}

#Preview {
    RegistrationView()
}
