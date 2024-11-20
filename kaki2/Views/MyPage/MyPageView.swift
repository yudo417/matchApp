//
//  MyPageView.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/07.
//

import SwiftUI

struct MyPageView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showEditProfileView = false
    @State private var showDeleteAlert = false

    var body: some View {
        List{

            // User info
            userinfo

            Section(header: Text("一般")) {

                MyPageRow(iconName: "gear", label: "バージョン", tintColor: .gray, value: "1.0.0")
            }

            //navigation
            Section(header:Text("アカウント")){
                Button {
                    showEditProfileView.toggle()
                } label: {

                    MyPageRow(iconName: "square.and.pencil.circle.fill", label: "プロフィール変更", tintColor: .red)
                }
                Button {
                    authViewModel.logout()
                } label: {
                    MyPageRow(iconName: "arrow.left.circle.fill", label: "ログアウト", tintColor: .red)
                }
                Button {
                    showDeleteAlert = true

                } label: {
                    MyPageRow(iconName: "xmark.circle.fill", label: "アカウント削除", tintColor: .red)
                }
                .alert("アカウント削除", isPresented: $showDeleteAlert) {
                    Button("キャンセル",role:.cancel){}
                    Button("削除",role: .destructive){
                        Task{
                            await authViewModel.deleteAccount()
                        }
                    }


                } message: {
                    Text("アカウントを削除しますか？")
                }


            }
        }
        .sheet(isPresented: $showEditProfileView) {
            EditProfileView()
        }
    }
}

#Preview {
    MyPageView().environmentObject(AuthViewModel())
}


extension MyPageView {
    private var userinfo:some View{
        Section{
            HStack(spacing:16){

                if let urlString = authViewModel.currentUser?.photoUrl,let url = URL(string: urlString){
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                    }

                }else{

                    Image("avatar")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 48, height: 48)
                }

                VStack(alignment:.leading,spacing: 4){
                    Text(authViewModel.currentUser?.name ?? "")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(authViewModel.currentUser?.email ?? "")
                        .font(.footnote)
                        .tint(.gray)
                }
            }
        }
    }
}
