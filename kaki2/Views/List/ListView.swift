//
//  ListView.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/09/25.
//

import SwiftUI

struct ListView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject private var viewModel = ListViewModel()
    var body: some View {

        NavigationStack{
            Group{
                if viewModel.users.count > 0{

                    VStack(spacing:0){

                        //Cards
                        cards

                        //Action
                        actions

                    }
                    .background(.black,in: RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal,7)





                }else{
                    ProgressView("loading")
                        .font(.headline)
                        .padding()
                        .tint(.white)
                        .background(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Fire Match")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink{
                        MyPageView()
                    }label:{
                        Group{
                            if let urlString = authViewModel.currentUser?.photoUrl, let url = URL(string: urlString){
                                AsyncImage(url:url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ProgressView()
                                }

                            }else{
                                Image("avatar")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 32, height: 32)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    BrandImage(size: .small)
                }
            }
        }
        .tint(.primary)
    }
}

#Preview {
    ListView()
}

extension ListView{
    private var cards: some View{
        ZStack{
            ForEach(viewModel.users.reversed()){ user in
                CardView(user: user) { isRedo in
                    viewModel.adjustIndex(isRedo: isRedo)
                }
            }
        }
    }

    //MARK: -action
    private var actions: some View{
        HStack(spacing: 68){

            ForEach(Action.allCases,id:\.self){ type in
                type.createActionButton(viewModel: viewModel)
            }
        }
        .foregroundColor(.white)
        .frame(height:100)
    }
}
