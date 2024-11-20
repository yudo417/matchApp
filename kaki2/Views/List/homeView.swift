//
//  homeView.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/10/06.
//

import SwiftUI

struct homeView: View {
    
    @ObservedObject var authViewModel = AuthViewModel()

    var body: some View {

        Group{
            if authViewModel.userSession != nil{
                ListView()
            }else{
                LoginView()
            }
        }
        .environmentObject(authViewModel)
    }
}

#Preview {
    homeView()
}
